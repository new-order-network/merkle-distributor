// SPDX-License-Identifier: GPL-3.0-only
pragma solidity =0.8.4;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "./MerkleProof.sol";
import "./interfaces/IMerkleDistributor.sol";

contract MerkleDistributor is IMerkleDistributor, Ownable, Pausable {
    address public immutable override token;
    bytes32 public override merkleRoot;
    using SafeERC20 for IERC20;

    /// inheritdoc IMerkleDistributor
    mapping(address => uint256) public override claimed;

    constructor(
        address token_,
        bytes32 merkleRoot_,
        address owner_
    ) {
        token = token_;
        merkleRoot = merkleRoot_;
        transferOwnership(owner_);
    }

    /// inheritdoc IMerkleDistributor
    function claim(
        uint256 index,
        address account,
        uint256 amount,
        bytes32[] calldata merkleProof
    ) external override whenNotPaused{
        uint256 alreadyClaimed = claimed[account];
        require(
            amount > alreadyClaimed,
            "MerkleDistributor: airdrop limit reached"
        );

        // Verify the merkle proof.
        bytes32 node = keccak256(abi.encodePacked(index, account, amount));
        require(
            MerkleProof.verify(merkleProof, merkleRoot, node),
            "MerkleDistributor: Invalid proof."
        );

        // Mark it claimed and send the token.
        claimed[account] = amount;
        uint256 airdropAmount = amount - alreadyClaimed;
        IERC20(token).safeTransfer(account, airdropAmount);

        emit Claimed(index, account, airdropAmount);
    }

    /// inheritdoc IMerkleDistributor
    function updateMerkleRoot(bytes32 newMerkleRoot) public override onlyOwner {
        emit UpdateMerkleRoot(msg.sender, merkleRoot, newMerkleRoot);
        merkleRoot = newMerkleRoot;
    }

    /// inheritdoc IMerkleDistributor
    function withdrawToken(address to, uint256 amount)
        public
        override
        onlyOwner
    {
        require(to != address(0), "to address is the zero address");
        require(amount > 0, "Amount is zero");
        require(
            IERC20(token).balanceOf(address(this)) >= amount,
            "Amount exceeds balance"
        );
        IERC20(token).safeTransfer(to, amount);
        emit WithdrawToken(msg.sender, to, amount);
    }

    /// inheritdoc IMerkleDistributor
    function withdrawAllTokens(address to) public override onlyOwner {
        withdrawToken(to, IERC20(token).balanceOf(address(this)));
    }
}
