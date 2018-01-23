dataset={};
print(dataset);

function dataset:size() return 5 end -- 100 examples
  
for i=1,dataset:size() do
    local input= torch.randn(2);     --normally distributed example in 2d
    print(input);
    local output= torch.Tensor(1);
    print(output);
    
    if input[1]*input[2]>0 then    --calculate label for XOR function
        output[1]=-1;
    else
        output[1]=1;
    end
    dataset[i] = {input, output};
end

-- print(dataset);