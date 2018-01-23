

-- Torch program that creates a simple AutoEncoder-style neural network, where output=input
print('\n\n @ @ @ @ @ @ START @ @ @ @ @ @ @ ');
print('Torch program that creates a simple AutoEncoder-style neural network, where output=input');
print('author Davide Chicco <davide.chicco@gmail.com>');
print(os.date("%c", os.time()));


sampleNumber = 5;
dataset = {} -- declaration of the input dataset
function dataset:size() return sampleNumber end -- input dataset hgas 

inputs=20; -- the inputs layer has dimension 20
outputs=inputs; -- the inputs has dimension 20 -- if it's not an Auto-Encoder, outputs =1 or another number
HUs=11; -- Hidden units
concats = 2 -- number of concatenations in the dataset creation

print('parameters:')
print('sampleNumber= ' .. sampleNumber .. ' inputs= ' .. inputs .. ' outputs= ' .. outputs .. ' HUs: ' .. HUs);

print('\n-- data building --');
-- data building
for i=1,dataset:size() do	-- 15 times
    input= torch.Tensor(inputs);
    for j=1, inputs do		-- 20 times
       a = math.random()
     if(a>=0.5) then input[j] = 0; -- each element in randomly set to zero or one
     else input[j]=1;
     end
    end   
    dataset[i] = {input, input} -- dataset is a matrix 15x2, where each element is a DoubleTensor of size 20   
				-- or it can be considered: an input matrix 20x15 and an output matrix 20x15, placed side by side
end

 -- print('dataset:dim() ',dataset:dim());
 print('dataset:size() ',dataset:size());
--  print('dataset[1]:size() ',dataset[1]:size());
-- print('dataset[1]:nDimension() ',dataset[1]:nDimension());
 -- print('dataset[1] ',dataset[1]);

 
-- here we print the content of the matrix dataset
for i=1,sampleNumber do
  for j=1,concats do
       print('dataset[' .. i .. '][' .. j .. ']', dataset[i][j]);
  end  
  
end    

-- Creation of the neural network
print('-- creation of the neural network --');
require "nn"
mlp=nn.Sequential();  -- make a multi-layer perceptron
mlp:add(nn.Linear(inputs,HUs)) -- adds a (input x HUs)  layer to the network
mlp:add(nn.Sigmoid());
mlp:add(nn.Linear(HUs,outputs)) -- adds a (HUs x outputs)  layer to the network
mlp:add(nn.Sigmoid()); -- Sigmoid also in output, Peter says

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
     b = math.random()
     if(b>=0.5) then x[u] = 0; -- each element in randomly set to zero or one
     else x[u]=1;
     end
    end   
    
-- here we print the content of the x dataset
for i=1,inputs do
       print('x[' .. i .. ']', x[i]);
  
end     
    
pred=mlp:forward(x)  -- applies the module mlp to x
print('pred:\n', pred)          -- print it 

print('@ @ @ @ @ END @ @ @ @ @ ');