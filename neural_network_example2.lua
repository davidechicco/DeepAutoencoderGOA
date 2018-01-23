-- dataset={};
-- function dataset:size() return 100 end -- 100 examples
-- for i=1,dataset:size() do
--     local input= torch.randn(2);     --normally distributed example in 2d
--     local output= torch.Tensor(1);
--     if input[1]*input[2]>0 then    --calculate label for XOR function
--         output[1]=-1;
--     else
--         output[1]=1;
--     end
--     dataset[i] = {input, output};
-- end

inputSize = 5;

--[[
dataset = {}
function dataset:size() return 25 end

-- data building
dataset = torch.Tensor(inputSize);
dataset=torch.Tensor(inputSize,inputSize)
for i=1,inputSize do
 for j=1,inputSize do
   a=math.random();
   if(a>=0.5) then dataset[i][j] = 0.0;
   else dataset[i][j]=1.0;
   end
 end
end]]

dataset = {}
function dataset:size() return 5 end
inputs=5; HUs=4; outputs=5;  -- @Peter: why HUs=20 ? What is HUs?

-- data building
-- dataset = torch.Tensor(inputSize);
-- dataset=torch.Tensor(inputSize,inputSize)
for i=1,dataset:size() do
    dataset[i] = {torch.randn(inputs), torch.Tensor(outputs)}
end

for i=1,inputSize do
  for j=1,2 do
       print('dataset[' .. i .. '][' .. j .. ']', dataset[i][j]);
  end  
  
end    
    
require "nn"
mlp=nn.Sequential();  -- make a multi-layer perceptron

mlp:add(nn.Linear(inputs,HUs))
mlp:add(nn.Tanh())
mlp:add(nn.Linear(HUs,outputs))

criterion = nn.MSECriterion() 
trainer = nn.StochasticGradient(mlp, criterion)
trainer.learningRate = 0.01
trainer:train(dataset)

x=torch.Tensor(inputs);   -- create a test example Tensor
x[1]=0.1; 
x[2]=0.2; -- set its values
x[3]=0.3; 
x[4]=0.4;
x[5]=0.5; 
pred=mlp:forward(x)  -- get the prediction of the mlp
print(pred)          -- print it 