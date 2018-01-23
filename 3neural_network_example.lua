

-- Torch program that creates a simple AutoEncoder-style neural network, where output=input
print('\n\n @ @ @ @ @ @ START @ @ @ @ @ @ @ ');
print('Torch program that creates a simple AutoEncoder-style neural network, where output=input');
inputSize = 5;


dataset = {} -- declaration of the input dataset
function dataset:size() return inputSize end -- input dataset hgas 

inputs=20; -- the inputs has dimension 1
outputs=inputs; -- the inputs has dimension 1 -- if it's not an Auto-Encoder, outputs =1 or another number
HUs=11; -- Hidden units
concats = 2 -- number of concatenations in the dataset creation

print('parameters:')
print('inputs= ' .. inputs .. ' outputs= ' .. outputs .. ' HUs: ' .. HUs);

print('-- data building --');
-- data building
for i=1,dataset:size() do
    a = math.random()
    input= torch.Tensor(inputs);
    for j=1, inputs do
     if(a>=0.5) then input[j] = 0; -- each element in randomly set to zero or one
     else input[j]=1;
     end
    end   
    dataset[i] = {input, input} -- dataset is a matrix 5x2, where each element is a DoubleTensor of size 1    
end

 -- print('dataset:dim() ',dataset:dim());
 print('dataset:size() ',dataset:size());
--  print('dataset[1]:size() ',dataset[1]:size());
-- print('dataset[1]:nDimension() ',dataset[1]:nDimension());
 -- print('dataset[1] ',dataset[1]);

 
-- here we print the content of the matrix dataset
for i=1,inputSize do
  for j=1,concats do
       print('dataset[' .. i .. '][' .. j .. ']', dataset[i][j]);
  end  
  
end    

-- Creation of the neural network
print('-- creation of the neural network --');
require "nn"
mlp=nn.Sequential();  -- make a multi-layer perceptron
mlp:add(nn.Linear(inputs,HUs)) -- adds a (input x HUs)  layer to the network
mlp:add(nn.Tanh())
mlp:add(nn.Linear(HUs,outputs)) -- adds a (HUs x outputs)  layer to the network

-- Training
print('-- training --');
criterion = nn.MSECriterion() 
trainer = nn.StochasticGradient(mlp, criterion)
trainer.learningRate = 0.01
trainer:train(dataset)

-- Testing
print('-- testing --');
x=torch.Tensor(inputs);   -- create a test example Tensor. Test element: x
for u=1, inputs do
     if(a>=0.5) then x[u] = 0; -- each element in randomly set to zero or one
     else x[u]=1;
     end
    end   
pred=mlp:forward(x)  -- get the prediction of the mlp
print('pred:\n', pred)          -- print it 

print('@ @ @ @ @ END @ @ @ @ @ ');