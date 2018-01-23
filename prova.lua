x=torch.Tensor(5,5)
for i=1,5 do
 for j=1,5 do
   a=math.random();
   if(a>=0.5) then x[i][j] = 0;
   else x[i][j]=1;
   end
 end
end

print(x);