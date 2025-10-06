// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface IEnergyPay {
    error TransferError(); // when transfer of asset fails

    /// @notice Emitted when a payment is made
    event Payment(uint256 indexed tokenId, uint256 amount);

    /**
     * @notice Get the cumulative amount of asset paid for a specific token ID
     * @param tokenId The token ID of the m3ter
     * @return The cumulative amount paid for the asset
     */
    function cumulativePaid(uint256 tokenId) external returns (uint256);

    /**
     * @notice Pay a specific amount of the asset for a specific token ID
     * @param tokenId The token ID of the m3ter
     * @param amount The amount of the asset to pay
     * @dev This function accepts payment from a superchain erc20 asset and bridges it to the m3ter's token TBA on mainnet
     */
    function pay(uint256 tokenId, uint256 amount) external;

    /**
     * @notice Get the address of the asset used for payments
     * @return The address of the asset
     */
    function asset() external returns (address);
}
