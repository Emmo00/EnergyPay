// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import {IERC20} from "@openzeppelin/contracts/interfaces/IERC20.sol";

/// @title OptimismMintableERC20
/// @notice OptimismMintableERC20 is a standard extension of the base ERC20 token contract designed
///         to allow the StandardBridge contracts to mint and burn tokens. This makes it possible to
///         use an OptimismMintableERC20 as the L2 representation of an L1 token, or vice-versa.
///         Designed to be backwards compatible with the older StandardL2ERC20 token which was only
///         meant for use on L2.
interface ISuperERC20 is IERC20 {
    /// @notice Emitted whenever tokens are minted for an account.
    /// @param account Address of the account tokens are being minted for.
    /// @param amount  Amount of tokens minted.
    event Mint(address indexed account, uint256 amount);

    /// @notice Emitted whenever tokens are burned from an account.
    /// @param account Address of the account tokens are being burned from.
    /// @param amount  Amount of tokens burned.
    event Burn(address indexed account, uint256 amount);

    /// @dev Returns the number of decimals used to get its user representation.
    /// For example, if `decimals` equals `2`, a balance of `505` tokens should
    /// be displayed to a user as `5.05` (`505 / 10 ** 2`).
    /// NOTE: This information is only used for _display_ purposes: it in
    /// no way affects any of the arithmetic of the contract, including
    /// {IERC20-balanceOf} and {IERC20-transfer}.
    function decimals() external view returns (uint8);

    /// @notice Returns the allowance for a spender on the owner's tokens.
    ///         If the spender is the permit2 address, returns the maximum uint256 value.
    /// @param _owner   owner of the tokens.
    /// @param _spender spender of the tokens.
    /// @return Allowance for the spender.
    function allowance(address _owner, address _spender) external view returns (uint256);

    /// @notice Allows the StandardBridge on this network to mint tokens.
    /// @param _to     Address to mint tokens to.
    /// @param _amount Amount of tokens to mint.
    function mint(address _to, uint256 _amount) external;

    /// @notice Allows the StandardBridge on this network to burn tokens.
    /// @param _from   Address to burn tokens from.
    /// @param _amount Amount of tokens to burn.
    function burn(address _from, uint256 _amount) external;

    /// @notice ERC165 interface check function.
    /// @param _interfaceId Interface ID to check.
    /// @return Whether or not the interface is supported by this contract.
    function supportsInterface(bytes4 _interfaceId) external pure returns (bool);

    /// @custom:legacy
    /// @notice Legacy getter for the remote token. Use REMOTE_TOKEN going forward.
    function l1Token() external view returns (address);

    /// @custom:legacy
    /// @notice Legacy getter for the bridge. Use BRIDGE going forward.
    function l2Bridge() external view returns (address);

    /// @custom:legacy
    /// @notice Legacy getter for REMOTE_TOKEN.
    function remoteToken() external view returns (address);

    /// @custom:legacy
    /// @notice Legacy getter for BRIDGE.
    function bridge() external view returns (address);
}
