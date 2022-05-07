// SPDX-License-Identifier: GPL-3.0-only
pragma solidity =0.8.4;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
//import "./MerkleProof.sol";
import "./MerkleProof.sol";
import "./interfaces/IMerkleDistributor.sol";

contract MerkleDistributor is IMerkleDistributor, Ownable {
    address public immutable override token;
    bytes32 public override merkleRoot;

    // This is a packed array of booleans.
    mapping(uint256 => uint256) private claimedBitMap;

    constructor(address token_, bytes32 merkleRoot_, address owner_) {
        token = token_;
        merkleRoot = merkleRoot_;
        transferOwnership(owner_);
    }

    function isClaimed(uint256 index) public view override returns (bool) {
        uint256 claimedWordIndex = index / 256;
        uint256 claimedBitIndex = index % 256;
        uint256 claimedWord = claimedBitMap[claimedWordIndex];
        uint256 mask = (1 << claimedBitIndex);
        return claimedWord & mask == mask;
    }

    function _setClaimed(uint256 index) private {
        uint256 claimedWordIndex = index / 256;
        uint256 claimedBitIndex = index % 256;
        claimedBitMap[claimedWordIndex] = claimedBitMap[claimedWordIndex] | (1 << claimedBitIndex);
    }

    function claim(uint256 index, address account, uint256 amount, bytes32[] calldata merkleProof) external override {
        require(!isClaimed(index), 'MerkleDistributor: Drop already claimed.');

        // Verify the merkle proof.
        bytes32 node = keccak256(abi.encodePacked(index, account, amount));
        require(MerkleProof.verify(merkleProof, merkleRoot, node), 'MerkleDistributor: Invalid proof.');

        // Mark it claimed and send the token.
        _setClaimed(index);
        //require(IERC20(token).transfer(account, amount), 'MerkleDistributor: Transfer failed.');
        SafeERC20.safeTransfer(IERC20(token), account, amount);

        emit Claimed(index, account, amount);
    }

    function updateMerkleRoot(bytes32 newMerkleRoot) onlyOwner public {
        emit UpdateMerkleRoot(msg.sender, merkleRoot, newMerkleRoot);
        merkleRoot = newMerkleRoot;
    }

    function withdrawToken(address to, uint amount) onlyOwner public {
        require(to != address(0), "to address is the zero address");
        require(amount > 0, "Amount is zero");
        require(IERC20(token).balanceOf(address(this)) >= amount, "Amount exceeds balance");
        SafeERC20.safeTransfer(IERC20(token), to, amount);
        emit WithdrawToken(msg.sender, to, amount);
    }

    function withdrawAllTokens(address to) onlyOwner public {
        withdrawToken(to, IERC20(token).balanceOf(address(this)));
    }
}
