type Program = [Instruction]
type Address = Int   -- 16-bit?
type Value = Int     -- 8-bit?

data Instruction = Real RealInstruction | Virtual VirtualInstruction deriving (Show, Eq)

data VirtualInstruction = Label String | Origin Address deriving (Show, Eq)

type IOPort = Value

data JumpCondition = Unconditionally |
                     IfZero | IfNonZero |
                     IfCarry | IfNoCarry |
                     IfParityOdd | IfParityEven |
                     IfPositive | IfNegative |

data ResetVector = Zero | One | Two | Three | Four | Five | Six | Seven | 

data SingleRegister = A | B | C | D | E | H | L | M
data RegisterOrImmediate = Register SingleRegister | Immediate Value

data RegisterPair = BC | DE | HL
data RegisterPairOrSP = Registers RegisterPair | SP
data RegisterPairOrPSW = RegisterPair | PSW

data RotateDirection = Left | Right

data LoadableRegisterPair = BC | DE | ImmAddress Address

data RealInstruction =
    -- Control
    Nop | Halt | Out IOPort | In IOPort | DisableInterrupts | EnableInterrupts |
    -- Jumps/Calls
    Jump JumpCondition Address | Call JumpCondition Address | Return JumpCondition | 
    Reset ResetVector | JumpToHL | 
    -- Arithmetic 8 bit
    Add RegisterOrImmediate | Sub RegisterOrImmediate |
    AddWithCarry RegisterOrImmediate | SubWithBorrow RegisterOrImmediate |
    And RegisterOrImmediate | Or RegisterOrImmediate | Xor RegisterOrImmediate |
    Compare RegisterOrImmediate |
    Increment Register | Decrement Register |
    Rotate RotateDirection | RotateThruCarry RotateDirection |
    ConvertIntoBCD |
    BinaryInvert | 
    SetCarry | FlipCarry |
    -- Arithmetic 16 bit
    IncrementX RegisterPairOrSP | DecrementX RegisterPairOrSP | DoubleAdd RegisterPairOrSP |
    -- Moves 8 bit
    Move Register RegisterOrImmediate |  -- !!! MOV M, M is invalid!
    LoadFromAddress LoadableRegisterPair | StoreToAddress LoadableRegisterPair |
    -- Moves 16 bit
    Push RegisterPairOrPSW | Pop RegisterPairOrPSW |
    SwapDEwithHL | 
    SwapHLwithStack |
    LoadSPfromHL |
    LoadImmediateX RegisterPairOrSP Address |
    StoreHLIntoAddress Address | LoadHLFromAddress Address |
