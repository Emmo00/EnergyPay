// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {IEnergyPay} from "./interfaces/IEnergyPay.sol";
import {IERC6551Registry} from "./interfaces/IERC6551Registry.sol";
import {ISuperchainERC20} from "optimism/interfaces/L2/ISuperchainERC20.sol";
import {IL2StandardBridge} from "optimism/interfaces/L2/IL2StandardBridge.sol";

/// @title EnergyPay
/// @notice A contract that facilitates payments to m3ter NFTs using a specified ERC-20 asset.
/// @dev This contract interacts with the SuperChain Token Bridge to forward payments to Token Bound Accounts
/// (TBAs) associated with m3ter NFTs. It also keeps track of cumulative payments made to each m3ter NFT.
contract EnergyPay is IEnergyPay {
    /// @inheritdoc IEnergyPay
    address public immutable asset;
    /// @notice The address of the m3ter NFT contract.
    address public immutable m3terNFT;
    /// @notice The address of the ERC-6551 registry contract.
    address public immutable TBARegistry;
    /// @notice The address of the ERC-6551 implementation contract.
    address public immutable TBAImplementation;
    /// @notice The address of the L1 Standard Bridge contract.
    address public constant l1StandardBridge = 0x4200000000000000000000000000000000000028;

    // tokenId => cumulativePaid
    /// @inheritdoc IEnergyPay
    mapping(uint256 => uint256) public cumulativePaid;

    constructor(address _asset, address _m3terNFT, address _TBARegistry, address _TBAImplementation) {
        asset = _asset;
        m3terNFT = _m3terNFT;
        TBARegistry = _TBARegistry;
        TBAImplementation = _TBAImplementation;
    }

    /// @inheritdoc IEnergyPay
    function pay(uint256 tokenId, uint256 amount) external returns (bytes32 msgHash) {
        // collect payment from sender
        ISuperchainERC20(asset).transferFrom(msg.sender, address(this), amount);
        // forward payment to TBA
        IL2StandardBridge(l1StandardBridge).withdrawTo(
            asset,
            _m3terTBA(tokenId),
            amount,
            200000, // minGasLimit
            "" // extraData
        );

        cumulativePaid[tokenId] += amount;
    }

    /**
     * @notice Computes the address of the Token Bound Account (TBA) associated with a given m3ter NFT token ID.
     * @param tokenId The token ID of the m3ter NFT.
     * @return The address of the TBA associated with the given m3ter NFT token ID.
     */
    function _m3terTBA(uint256 tokenId) internal view returns (address) {
        return IERC6551Registry(TBARegistry).account(
            TBAImplementation,
            0x0, // salt
            1, // chainId
            m3terNFT,
            tokenId
        );
    }
}
