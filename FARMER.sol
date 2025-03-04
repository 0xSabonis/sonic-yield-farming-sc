// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// OpenZeppelin Contracts v5.0.1

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 */
abstract contract ReentrancyGuard {
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;
    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    modifier nonReentrant() {
        require(_status != _ENTERED, "R1");
        _status = _ENTERED;
        _;
        _status = _NOT_ENTERED;
    }
}

/**
 * @dev Contract module which provides a basic access control mechanism
 */
abstract contract Ownable {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor(address initialOwner) {
        if (initialOwner == address(0)) {
            revert("O1");
        }
        _transferOwnership(initialOwner);
    }

    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    function _checkOwner() internal view virtual {
        require(owner() == msg.sender, "O2");
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "O1");
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

/**
 * @dev Implementation of the {IERC20} interface.
 */
contract ERC20 is IERC20 {
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;
    string private _name;
    string private _symbol;

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    function name() public view virtual returns (string memory) {
        return _name;
    }

    function symbol() public view virtual returns (string memory) {
        return _symbol;
    }

    function decimals() public view virtual returns (uint8) {
        return 18;
    }

    function totalSupply() public view virtual returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view virtual returns (uint256) {
        return _balances[account];
    }

    function transfer(address to, uint256 amount) public virtual returns (bool) {
        address owner = msg.sender;
        _transfer(owner, to, amount);
        return true;
    }

    function allowance(address owner, address spender) public view virtual returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public virtual returns (bool) {
        address owner = msg.sender;
        _approve(owner, spender, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public virtual returns (bool) {
        address spender = msg.sender;
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }

    function _transfer(address from, address to, uint256 amount) internal virtual {
        require(from != address(0) && to != address(0), "E1");
        _beforeTokenTransfer(from, to, amount);
        uint256 fromBalance = _balances[from];
        require(fromBalance >= amount, "E2");
        unchecked {
            _balances[from] = fromBalance - amount;
            _balances[to] += amount;
        }
        emit Transfer(from, to, amount);
        _afterTokenTransfer(from, to, amount);
    }

    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "E3");
        _beforeTokenTransfer(address(0), account, amount);
        _totalSupply += amount;
        unchecked {
            _balances[account] += amount;
        }
        emit Transfer(address(0), account, amount);
        _afterTokenTransfer(address(0), account, amount);
    }

    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0) && spender != address(0), "E4");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        require(currentAllowance >= amount, "E5");
        unchecked {
            _approve(owner, spender, currentAllowance - amount);
        }
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {
    }

    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {
    }
}

interface IMetropolisRouter {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);
    
    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);

    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    
    function swapExactTokensForETH(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    
    function swapExactTokensForWETH(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    
    function swapExactWETHForETH(
        uint wethAmount,
        uint amountOutMin,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
}

interface IMetropolisFactory {
    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

interface IMetropolisPair {
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
}

// SwapProxy interface
interface ISwapProxy {
    function sendETHToFarmer() external;
}

// FARMER Token Contract
contract FARMER is ERC20, ReentrancyGuard, Ownable {
    // Constants
    uint256 private constant TOTAL_SUPPLY = 1_000_000 * 10**18;
    uint256 private constant TAX_RATE = 5; // 5%
    uint256 private constant LIQUIDITY_TAX = 25; // 2.5%
    uint256 private constant AIRDROP_TAX = 25; // 2.5%
    uint256 private constant MIN_HOLDER_AMOUNT = 10 * 10**18; // 10 tokens minimum for holder status
    uint256 private constant MIN_TOKENS_FOR_PROCESS = 50 * 10**18;
    uint256 private constant SWAP_PERCENTAGE = 75; // 75% will be swapped
    uint256 private constant LIQUIDITY_PERCENTAGE = 25; // 25% will be used for liquidity
    uint256 private constant MAX_SLIPPAGE = 100;
    uint256 private constant MIN_PROCESSING_INTERVAL = 30 minutes; // Minimum interval between auto processing

    // Metropolis DEX addresses
    IMetropolisRouter public metropolisRouter;
    IMetropolisFactory public metropolisFactory;
    address public sonicToken;
    address public liquidityPair;
    address public treasuryWallet;

    // Holder tracking
    mapping(address => bool) public isHolder;
    address[] public holders;

    // Events
    event LiquidityAdded(uint256 tokenAmount, uint256 sonicAmount);
    event AirdropDistributed(uint256 amount, uint256 holdersCount);
    event SwapFailed(string reason);
    event ProcessStarted(uint256 tokensForLiquidity, uint256 tokensForAirdrop);
    event SwapSuccessful(uint256 tokensSwapped, uint256 wethReceived);
    event TreasuryWalletUpdated(address oldTreasury, address newTreasury);
    event LiquidityAddFailed(string reason);
    event AirdropFailed(string reason);
    event ApprovalRefreshed(address token, address spender, uint256 amount);
    event WaitingForTreasuryTransfer(uint256 amount);
    event SwapProxySet(address indexed proxyAddress);
    event ManualSwapCompleted(uint256 tokenAmount, uint256 ethReceived);
    event ETHReceived(address indexed sender, uint256 amount);
    event ProcessorRewarded(address indexed processor, uint256 amount);
    event ReadyForProcessing(uint256 pendingAmount, uint256 minGasLimit);
    event LPTokenReceived(address indexed receiver, uint256 amount);
    event RewardAvailableForProcessing(uint256 pendingAmount, uint256 estimatedRewardPercentage);

    uint256 private _pendingLiquidityTokens;
    uint256 private _pendingAirdropTokens;
    bool private _initialized;
    bool private _inSwap;

    address public swapProxy;
    bool public swapProxySet;
    
    uint256 private _lastProcessingTime;

    constructor() ERC20("FARMER", "FARM") Ownable(msg.sender) {
        address _metropolisRouter = 0x0000000000000000000000000000000000000000; //metropolis_router_ca_here;
        address _metropolisFactory = 0x0000000000000000000000000000000000000000; //metropolis_factory_ca_here;
        address _sonicToken = 0x0000000000000000000000000000000000000000; //wrapped_sonic_token_ca_here;
        address _treasuryWallet = 0x0000000000000000000000000000000000000000; //treasury_wallet_here;

        require(_metropolisRouter != address(0) && _metropolisFactory != address(0) && _sonicToken != address(0) && _treasuryWallet != address(0), "F1");

        metropolisRouter = IMetropolisRouter(_metropolisRouter);
        metropolisFactory = IMetropolisFactory(_metropolisFactory);
        sonicToken = _sonicToken;
        treasuryWallet = _treasuryWallet;

        _mint(address(this), TOTAL_SUPPLY);
    }

    function initialize() external onlyOwner {
        require(!_initialized, "F2");
        _initialized = true;

        // Try to get existing pair first
        liquidityPair = metropolisFactory.getPair(address(this), sonicToken);
        
        // If pair doesn't exist, create it
        if (liquidityPair == address(0)) {
            liquidityPair = metropolisFactory.createPair(address(this), sonicToken);
        }
        
        require(liquidityPair != address(0), "F3");

        _approve(address(this), address(metropolisRouter), type(uint256).max);
        
        require(IERC20(sonicToken).approve(address(metropolisRouter), type(uint256).max), "F4");
        IERC20(sonicToken).approve(liquidityPair, type(uint256).max);
        IERC20(address(this)).approve(liquidityPair, type(uint256).max);
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual override {
        if (
            !_inSwap && 
            from != owner() && 
            to != owner() && 
            from != address(this) && 
            to == liquidityPair
        ) {
            uint256 taxAmount = amount * TAX_RATE / 100;
            
            if (taxAmount > 0) {
                uint256 liquidityTokens = taxAmount * LIQUIDITY_TAX / 100;
                uint256 airdropTokens = taxAmount * AIRDROP_TAX / 100;
                
                uint256 transferAmount = amount - taxAmount;
                
                super._transfer(from, address(this), taxAmount);
                
                super._transfer(from, to, transferAmount);
                
                _pendingLiquidityTokens += liquidityTokens;
                _pendingAirdropTokens += airdropTokens;
                
                
                if (_pendingLiquidityTokens + _pendingAirdropTokens >= MIN_TOKENS_FOR_PROCESS) {
                    emit ProcessStarted(_pendingLiquidityTokens, _pendingAirdropTokens);
                    
                    emit ReadyForProcessing(_pendingLiquidityTokens + _pendingAirdropTokens, 400000);
                    
                    emit RewardAvailableForProcessing(_pendingLiquidityTokens + _pendingAirdropTokens, 5); // %5 ödül
                }
                
                _updateHolder(from, balanceOf(from) >= MIN_HOLDER_AMOUNT);
                _updateHolder(to, balanceOf(to) >= MIN_HOLDER_AMOUNT);
                
                return;
            }
        }
        
        super._transfer(from, to, amount);

        _updateHolder(from, balanceOf(from) >= MIN_HOLDER_AMOUNT);
        _updateHolder(to, balanceOf(to) >= MIN_HOLDER_AMOUNT);
    }

    function _updateHolder(address account, bool isHolderStatus) private {
        if (account != liquidityPair && account != address(this)) {
            if (isHolderStatus && !isHolder[account]) {
                isHolder[account] = true;
                holders.push(account);
            } else if (!isHolderStatus && isHolder[account]) {
                isHolder[account] = false;
                
                // Remove from holders array
                for (uint256 i = 0; i < holders.length; i++) {
                    if (holders[i] == account) {
                        holders[i] = holders[holders.length - 1];
                        holders.pop();
                        break;
                    }
                }
            }
        }
    }

    function processLiquidityAndAirdrop() external nonReentrant {
        require(!_inSwap, "AP");
        _inSwap = true;
        
        uint256 tokensForLiquidity = _pendingLiquidityTokens;
        uint256 tokensForAirdrop = _pendingAirdropTokens;
        
        if (tokensForLiquidity == 0 && tokensForAirdrop == 0) {
            _inSwap = false;
            return;
        }
        
        uint256 contractTokenBalance = balanceOf(address(this));
        uint256 totalTokensToProcess = tokensForLiquidity + tokensForAirdrop;
        
        if (contractTokenBalance < totalTokensToProcess) {
            emit SwapFailed("Insufficient token balance");
            _inSwap = false;
            return;
        }
        
        address caller = msg.sender;
        
        uint256 maxProcessAmount = 100 * 10**18;
        uint256 totalTokensToSwap = tokensForLiquidity + tokensForAirdrop;
        
        if (totalTokensToSwap > maxProcessAmount) {
            uint256 ratio = maxProcessAmount * 1e18 / totalTokensToSwap;
            tokensForLiquidity = tokensForLiquidity * ratio / 1e18;
            tokensForAirdrop = tokensForAirdrop * ratio / 1e18;
            totalTokensToSwap = tokensForLiquidity + tokensForAirdrop;
            
            _pendingLiquidityTokens -= tokensForLiquidity;
            _pendingAirdropTokens -= tokensForAirdrop;
        } else {
            _pendingLiquidityTokens = 0;
            _pendingAirdropTokens = 0;
        }
        
        _lastProcessingTime = block.timestamp;
        
        emit ProcessStarted(tokensForLiquidity, tokensForAirdrop);
        
        // Refresh approvals
        _approve(address(this), address(metropolisRouter), type(uint256).max);
        
        uint256 initialEthBalance = address(this).balance;
        
        uint256 ethReceived = _processSwap(totalTokensToSwap);
        
        if (ethReceived == 0) {
            _inSwap = false;
            return;
        }
        
        uint256 contractEthBalance = address(this).balance;
        if (contractEthBalance <= initialEthBalance) {
            emit SwapFailed("No ETH received from swap");
            _inSwap = false;
            return;
        }
        
        uint256 actualEthReceived = contractEthBalance - initialEthBalance;
        
        uint256 callerReward = 0;
        if (caller != owner() && caller != address(this)) {
            callerReward = actualEthReceived * 5 / 100;
            if (callerReward > 0) {
                (bool success, ) = caller.call{value: callerReward}("");
                if (!success) {
                    callerReward = 0;
                } else {
                    emit ProcessorRewarded(caller, callerReward);
                }
            }
        }
        
        actualEthReceived = actualEthReceived - callerReward;
        
        // Calculate amounts
        uint256 ethForLiquidity = actualEthReceived * tokensForLiquidity / totalTokensToSwap;
        uint256 ethForAirdrop = actualEthReceived - ethForLiquidity;
        
        if (ethForLiquidity > 0) {
            _addLiquidity(ethForLiquidity, tokensForLiquidity);
        }
        
        // Process airdrop with ETH
        if (ethForAirdrop > 0) {
            _processAirdropWithETH(ethForAirdrop);
        }
        
        _inSwap = false;
    }

    function _processLiquidity(uint256 wethAmount, uint256 tokenAmount) private {
    }

    function _addLiquidity(uint256 ethAmount, uint256 tokenAmount) private {
        uint256 contractTokenBalance = balanceOf(address(this));
        if (contractTokenBalance < tokenAmount) {
            emit LiquidityAddFailed("Insufficient token balance for liquidity");
            return;
        }

        uint256 minTokenAmount = tokenAmount * (100 - MAX_SLIPPAGE) / 100;
        uint256 minEthAmount = ethAmount * (100 - MAX_SLIPPAGE) / 100;
        
        _approve(address(this), address(metropolisRouter), tokenAmount);
        
        try metropolisRouter.addLiquidityETH{value: ethAmount}(
            address(this),
            tokenAmount,
            minTokenAmount,
            minEthAmount,
            owner(),
            block.timestamp + 3600
        ) {
            emit LiquidityAdded(tokenAmount, ethAmount);
            
            emit LPTokenReceived(owner(), 0);
        } catch Error(string memory reason) {
            emit LiquidityAddFailed(reason);
        } catch {
            emit LiquidityAddFailed("Unknown liquidity add error");
        }
    }

    function _processSwap(uint256 tokenAmount) private returns (uint256) {
        if (tokenAmount == 0) return 0;
        require(swapProxySet, "Swap proxy not set");
        
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = metropolisRouter.WETH();
        
        uint256 minAmountOut = 0;
        
        _approve(address(this), address(metropolisRouter), tokenAmount);
        
        uint256 deadline = block.timestamp + 3600;
        
        uint256 initialEthBalance = address(this).balance;
        
        try metropolisRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            minAmountOut,
            path,
            swapProxy,
            deadline
        ) {
            try ISwapProxy(swapProxy).sendETHToFarmer() {
                uint256 contractEthBalance = address(this).balance;
                uint256 ethReceived = contractEthBalance - initialEthBalance;
                
                if (ethReceived > 0) {
                    emit SwapSuccessful(tokenAmount, ethReceived);
                    return ethReceived;
                } else {
                    emit SwapFailed("No ETH received after proxy transfer");
                    return 0;
                }
            } catch Error(string memory reason) {
                emit SwapFailed(string(abi.encodePacked("Proxy ETH transfer failed: ", reason)));
                return 0;
            } catch {
                emit SwapFailed("Proxy ETH transfer failed: unknown error");
                return 0;
            }
        } catch Error(string memory reason) {
            emit SwapFailed(reason);
            return 0;
        } catch {
            emit SwapFailed("Unknown swap error");
            return 0;
        }
    }

    function _processAirdropWithETH(uint256 amount) private {
        uint256 holdersCount = holders.length;
        if (holdersCount == 0 || amount == 0) return;
        
        uint256 treasuryAmount = amount * 25 / 100;
        uint256 holderAmount = amount - treasuryAmount;
        
        if (treasuryAmount > 0 && treasuryWallet != address(0)) {
            (bool treasurySuccess, ) = treasuryWallet.call{value: treasuryAmount}("");
            if (!treasurySuccess) {
                emit AirdropFailed("Treasury ETH transfer failed");
                holderAmount = amount;
            }
        } else {
            holderAmount = amount;
        }
        
        if (holdersCount > 0 && holderAmount > 0) {
            uint256 amountPerHolder = holderAmount / holdersCount;
            if (amountPerHolder > 0) {
                for (uint256 i = 0; i < holdersCount; i++) {
                    address holder = holders[i];
                    if (holder != address(0) && holder != address(this) && holder != liquidityPair) {
                        (bool success, ) = holder.call{value: amountPerHolder}("");
                        if (!success) {
                            emit AirdropFailed("ETH transfer failed");
                        }
                    }
                }
            }
        }
        
        emit AirdropDistributed(amount, holdersCount);
    }

    // View functions
    function getHolderCount() external view returns (uint256) {
        return holders.length;
    }
    
    function getHolders() external view returns (address[] memory) {
        return holders;
    }
    
    function checkProcessingStatus() external view returns (
        bool readyForProcessing,
        uint256 pendingAmount,
        uint256 timeUntilNextProcessing,
        uint256 recommendedGasLimit
    ) {
        pendingAmount = _pendingLiquidityTokens + _pendingAirdropTokens;
        
        readyForProcessing = pendingAmount >= MIN_TOKENS_FOR_PROCESS;
        
        timeUntilNextProcessing = 0;
        
        recommendedGasLimit = 400000; // 400,000 gas units
    }

    // Initial liquidity function with WSonic
    function addInitialLiquidityWithWSonic(uint256 tokenAmount, uint256 sonicAmount) external onlyOwner {
        require(tokenAmount > 0, "NT");
        require(sonicAmount > 0, "NS");
        
        require(
            IERC20(address(this)).balanceOf(address(this)) >= tokenAmount,
            "IB"
        );
        
        require(
            IERC20(sonicToken).balanceOf(msg.sender) >= sonicAmount,
            "IS"
        );
        
        require(
            IERC20(sonicToken).transferFrom(msg.sender, address(this), sonicAmount),
            "TF"
        );
        
        _approve(address(this), address(metropolisRouter), tokenAmount);
        IERC20(sonicToken).approve(address(metropolisRouter), sonicAmount);
        
        try metropolisRouter.addLiquidity(
            address(this),
            sonicToken,
            tokenAmount,
            sonicAmount,
            0,
            0,
            msg.sender,
            block.timestamp + 600
        ) {
            emit LiquidityAdded(tokenAmount, sonicAmount);
        } catch Error(string memory reason) {
            _approve(address(this), address(metropolisRouter), 0);
            IERC20(sonicToken).approve(address(metropolisRouter), 0);
            
            IERC20(sonicToken).transfer(msg.sender, sonicAmount);
            
            revert(reason);
        } catch {
            _approve(address(this), address(metropolisRouter), 0);
            IERC20(sonicToken).approve(address(metropolisRouter), 0);
            
            IERC20(sonicToken).transfer(msg.sender, sonicAmount);
            
            revert("FL");
        }
        
        uint256 remainingWSonic = IERC20(sonicToken).balanceOf(address(this));
        if (remainingWSonic > 0) {
            IERC20(sonicToken).transfer(msg.sender, remainingWSonic);
        }
    }

    function addInitialLiquidityWithAllTokensAndETH() external payable onlyOwner {
        uint256 tokenAmount = IERC20(address(this)).balanceOf(address(this));
        require(tokenAmount > 0, "NT");
        require(msg.value > 0, "NE");
        
        _approve(address(this), address(metropolisRouter), tokenAmount);
        
        try metropolisRouter.addLiquidityETH{value: msg.value}(
            address(this),
            tokenAmount,
            0,
            0,
            msg.sender,
            block.timestamp + 600
        ) {
            emit LiquidityAdded(tokenAmount, msg.value);
        } catch Error(string memory reason) {
            _approve(address(this), address(metropolisRouter), 0);
            
            payable(msg.sender).transfer(address(this).balance);
            
            revert(reason);
        } catch {
            _approve(address(this), address(metropolisRouter), 0);
            
            payable(msg.sender).transfer(address(this).balance);
            
            revert("FL");
        }
    }

    function setRouter(address _router) external onlyOwner {
        require(_router != address(0), "IR");
        metropolisRouter = IMetropolisRouter(_router);
    }

    function rescueTokens(address _token, uint256 _amount) external onlyOwner {
        require(_token != address(this), "CF");
        IERC20(_token).transfer(owner(), _amount);
    }

    // View functions for pending amounts
    function getPendingLiquidityTokens() external view returns (uint256) {
        return _pendingLiquidityTokens;
    }

    function getPendingAirdropTokens() external view returns (uint256) {
        return _pendingAirdropTokens;
    }

    // Manual trigger for processing (anyone can call)
    function triggerProcessing() external {
        require(_pendingLiquidityTokens > 0 || _pendingAirdropTokens > 0, "NP");
        require(holders.length > 0, "NH");
        try this.processLiquidityAndAirdrop() {
            // Process successful
        } catch {
            emit ProcessStarted(_pendingLiquidityTokens, _pendingAirdropTokens);
        }
    }
    
    function processLiquidityAndAirdropAndGetReward() external {
        require(_pendingLiquidityTokens > 0 || _pendingAirdropTokens > 0, "NP: Islenecek token yok");
        require(holders.length > 0, "NH: Islem yapilacak holder bulunamadi");
        
        try this.processLiquidityAndAirdrop() {
        } catch Error(string memory reason) {
            emit SwapFailed(reason);
        } catch {
            emit SwapFailed("processLiquidityAndAirdrop basarisiz");
        }
    }

    function refreshAllApprovals() external onlyOwner {
        _approve(address(this), address(metropolisRouter), type(uint256).max);
        
        try IERC20(sonicToken).approve(address(metropolisRouter), type(uint256).max) {
            emit ApprovalRefreshed(sonicToken, address(metropolisRouter), type(uint256).max);
        } catch {}
        
        if (liquidityPair != address(0)) {
            try IERC20(sonicToken).approve(liquidityPair, type(uint256).max) {
                emit ApprovalRefreshed(sonicToken, liquidityPair, type(uint256).max);
            } catch {}
            
            try IERC20(address(this)).approve(liquidityPair, type(uint256).max) {
                emit ApprovalRefreshed(address(this), liquidityPair, type(uint256).max);
            } catch {}
        }
    }

    function manualSwap(uint256 tokenAmount) external onlyOwner nonReentrant {
        require(tokenAmount > 0, "Amount must be greater than 0");
        require(tokenAmount <= balanceOf(address(this)), "Insufficient balance");
        require(swapProxySet, "Swap proxy not set");
        
        uint256 ethReceived = _processSwap(tokenAmount);
        
        require(ethReceived > 0, "Swap failed, no ETH received");
        
        emit ManualSwapCompleted(tokenAmount, ethReceived);
    }

    function setTreasuryWallet(address newTreasuryWallet) external onlyOwner {
        require(newTreasuryWallet != address(0), "ZA");
        
        address oldTreasury = treasuryWallet;
        treasuryWallet = newTreasuryWallet;
        
        emit TreasuryWalletUpdated(oldTreasury, newTreasuryWallet);
    }

    function manualLiquidityAndAirdrop(uint256 tokenAmount) external onlyOwner {
        require(tokenAmount > 0, "NT");
        require(IERC20(address(this)).balanceOf(address(this)) >= tokenAmount, "IB");
        
        // Refresh approvals
        _approve(address(this), address(metropolisRouter), type(uint256).max);
        uint256 initialEthBalance = address(this).balance;
        uint256 ethReceived = _processSwap(tokenAmount);
        
        if (ethReceived == 0) {
            return;
        }
        
        uint256 contractEthBalance = address(this).balance;
        if (contractEthBalance <= initialEthBalance) {
            emit SwapFailed("No ETH received from swap");
            return;
        }
        
        uint256 actualEthReceived = contractEthBalance - initialEthBalance;
        
        // Calculate amounts
        uint256 ethForLiquidity = actualEthReceived * LIQUIDITY_TAX / 100;
        uint256 ethForAirdrop = actualEthReceived * AIRDROP_TAX / 100;
        
        if (ethForLiquidity > 0) {
            _addLiquidity(ethForLiquidity, tokenAmount * LIQUIDITY_TAX / 100);
        }
        // Process airdrop with ETH
        if (ethForAirdrop > 0) {
            _processAirdropWithETH(ethForAirdrop);
        }
    }

    receive() external payable {
        if (msg.value > 0) {
            emit ETHReceived(msg.sender, msg.value);
        }
    }

    function setSwapProxy(address _swapProxy) external onlyOwner {
        require(!swapProxySet, "Proxy already set");
        require(_swapProxy != address(0), "Invalid proxy address");
        swapProxy = _swapProxy;
        swapProxySet = true;
        emit SwapProxySet(_swapProxy);
    }
}