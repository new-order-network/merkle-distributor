// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.5.0;

// Allows anyone to claim a token if they exist in a merkle root.
interface IMerkleDistributor {
    /// Returns the address of the token distributed by this contract.
    function token() external view returns (address);
    /// Returns the merkle root of the merkle tree containing account balances available to claim.
    function merkleRoot() external view returns (bytes32);
    /// Returns the amount of airdrops claimed.
    function claimed(uint256 index) external view returns (uint256);
    /// Claim the given amount of the token to the given address. Reverts if the inputs are invalid.
    /// @param amount the TOTAL eligible amount of airdop in MerkleTree (including claimed amount).
    function claim(uint256 index, address account, uint256 amount, bytes32[] calldata merkleProof) external;
    /// Updates the root of the merkle tree.
    ///
    /// @dev The assumption is that the updated amount values of MerkleTree are total eligible airdrops for user.
    /// So if the new amount is greater than the previous, the delta will be considered new eligible airdrop amount
    /// when user claims. Conversely if the updated amount is less than previous, user will not be able to claim any more tokens.
    function updateMerkleRoot(bytes32 newMerkleRoot) external;
    /// Admin function. Withdraws token `to` provided address for the `amount`.
    function withdrawToken(address to, uint256 amount) external;
    /// Admin function. Withdraws all tokens `to` address.
    function withdrawAllTokens(address to) external;

    /// This event is triggered whenever a call to #claim succeeds.
    /// @param airdropAmount the new amount of airdrop transferred to user
    event Claimed(uint256 index, address account, uint256 airdropAmount);
    /// This event is triggered whenever a call to update merkle root succeeds.
    event UpdateMerkleRoot(address indexed owner, bytes32 previousRoot, bytes32 newRoot);
    /// This event is triggered whenever a call to withdraw token succeeds.
    event WithdrawToken(address indexed owner, address indexed to, uint amount);
}