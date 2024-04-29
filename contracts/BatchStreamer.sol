// SPDX-License-Identifier: MIT
pragma solidity =0.5.17;

import { IERC20 } from "./IERC20.sol";
import { SafeERC20 } from "./SafeERC20.sol";
import { ReentrancyGuard } from "./ReentrancyGuard.sol";

interface Stream{
    function createStream(address recipient, uint256 deposit, address tokenAddress, uint256 startTime, uint256 stopTime) external returns(uint256);
}

contract BatchStreamer is ReentrancyGuard{
    using SafeERC20 for IERC20;

    Stream public stream;
    
    event CreateBatchPayment(
        address indexed sender, 
        uint256 indexed totalAmount, 
        uint256[] indexed streamIds,
        uint256 timestamp
    );

    constructor(address _stream) public{
        require(_stream != address(0), "Invalid stream address");
        stream  = Stream(_stream);
    }
   
    function createBatchPayment(
        address[] calldata _recipients, 
        uint256[] calldata _deposits, 
        uint256[] calldata _startTimes, 
        uint256[] calldata _stopTimes,
        address _tokenAddress
        ) 
        external 
        nonReentrant
        returns(uint256[] memory streamIds)
    {
        uint256 i;
        uint256 totalAmount;
        uint256 batchSize = _recipients.length;

        require(batchSize > 0, "Batch size must be greator than zero" );

        for(i = 0; i < batchSize;){
            totalAmount += _deposits[i];
            i += 1;
        }

        _handleTransfer(IERC20(_tokenAddress), totalAmount);

        streamIds = new uint256[](batchSize);

        for(i = 0; i < batchSize;){
            streamIds[i] = stream.createStream({
                recipient: _recipients[i],
                deposit: _deposits[i],
                tokenAddress: _tokenAddress,
                startTime: _startTimes[i],
                stopTime: _stopTimes[i]
        });

            i += 1;
        }

        emit CreateBatchPayment({
            sender: msg.sender,
            totalAmount: totalAmount,
            streamIds: streamIds,
            timestamp: block.timestamp
        });
    }

    function _approve(address _streamContract, IERC20 _asset, uint256 _amount) internal{
        uint256 allowance = _asset.allowance({
            owner: address(this),
            spender: _streamContract
        });
        if(allowance < _amount){
            _asset.safeApprove({ spender: _streamContract, value: _amount });
        }
    }

    function _handleTransfer(IERC20 _asset, uint256 _amount) internal{
        _asset.safeTransferFrom({
            from : msg.sender,
            to: address(this),
            value: _amount
        });

        _approve(address(stream), _asset, _amount);
    }
}