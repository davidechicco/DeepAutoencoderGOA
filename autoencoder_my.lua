require 'nn'
require 'unsup'
inputSize = 5
outputSize = 5
beta = 1

-- creiamo 
input = torch.Tensor(5);
input=torch.Tensor(5,5)
for i=1,5 do
 for j=1,5 do
   a=math.random();
   if(a>=0.5) then input[i][j] = 0;
   else input[i][j]=1;
   end
 end
end

print(x);
encoder = nn.Sequential()
encoder:add(nn.Linear(inputSize,outputSize))
encoder:add(nn.Tanh())
decoder = nn.Sequential()
decoder:add(nn.Linear(outputSize,inputSize))

-- module e' un oggetto di tipo AutoEncoder
module = unsup.AutoEncoder(encoder, decoder, beta)
loss = module:updateOutput(input,input)
print('decoder.output', decoder.output);
print('loss', loss);

-- get parameters and gradient pointers
-- funziona che restituisce tutti i parametri dell'oggetto module, che sarebbe un AutoEncoder
x,dl_dx = module:getParameters()
-- cos'e' x?
-- dl_dx puntatori del gradiente?

dl_dx:zero() -- azzeriamo dl_dx

-- compute gradients wrt input and weights

module:updateGradInput(input, input)
module:accGradParameters(input, input)
-- at this stage, dl_dx contains the gradients of the loss wrt
-- the trainable parameters x

-- print('x', x);
 print('dl_dx', dl_dx);
 
 

