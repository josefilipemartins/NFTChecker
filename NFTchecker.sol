// SPDX-License-Identifier: MIT LICENSE
pragma solidity ^0.8.4;
import "./IERC721.sol";
import "./ERC165.sol";
import "./IStakingPool.sol";
import "./MainNFT.sol";
import "./Ownable.sol";
contract NFTchecker is ERC165, Ownable {
    MainNFT mainNFT;
    IStakingPool stakingPool;

    function setDependecies(address _nft, address _pool) external onlyOwner{
        mainNFT = MainNFT(_nft);
        stakingPool = IStakingPool(_pool);
    }
    
    function balanceOf(address _owner) public view returns (uint256) {
        uint256 numTokens;
        uint[] memory aux = new uint[](1);
        for (uint256 i = 0; i < mainNFT.totalSupply(); i++) {
            aux[0] = i;
            if (stakingPool.isOwnerOfStakedTokens(aux, _owner)) {
                numTokens++;
            }
        }
        return mainNFT.balanceOf(_owner) + numTokens;
    }

    /**
     * @inheritdoc ERC165
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165) returns (bool) {
        return interfaceId == type(IERC721).interfaceId || super.supportsInterface(interfaceId);
    }
}