// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {IEnergyPay} from "./interfaces/IEnergyPay.sol";
import {ISuperERC20} from "./interfaces/ISuperERC20.sol";
import {IERC6551Registry} from "./interfaces/IERC6551Registry.sol";

contract EnergyPay is IEnergyPay {
    /// @inheritdoc IEnergyPay
    address public immutable asset;
    /// @notice The address of the m3ter NFT contract.
    address public immutable m3terNFT;
    /// @notice The address of the ERC-6551 registry contract.
    address public immutable TBARegistry;
    /// @notice The address of the ERC-6551 implementation contract.
    address public immutable TBAImplementation;

    /// @inheritdoc IEnergyPay
    // tokenId => cumulativePaid
    mapping(uint256 => uint256) public cumulativePaid;

    constructor(address _asset, address _m3terNFT, address _TBARegistry, address _TBAImplementation) {
        asset = _asset;
        m3terNFT = _m3terNFT;
        TBARegistry = _TBARegistry;
        TBAImplementation = _TBAImplementation;
    }

    /// @inheritdoc IEnergyPay
    function pay(uint256 tokenId, uint256 amount) external {
        if (!ISuperERC20(asset).transferFrom(msg.sender, _m3terTBA(tokenId), amount)) {
            revert TransferError();
        }

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
