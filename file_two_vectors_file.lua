  
require 'os'
require './lib/AucComputer'
require './lib/round_functions'
require './lib/file_functions'


-- tests the functions above
-- file = './data/_prova_curva_roc.txt';
file = './data/_roc_curves.txt';
lines = lines_from(file);


tens1aux = {}
tens2aux  = {}


i =1
-- print all line numbers and their contents
for k,v in pairs(lines) do
	  j = 1
	  for token in string.gmatch(v, "[^%s]+") do
	    -- print(token)
	      if j==1 then tens1aux[i] =  tonumber(token); end
	      if j==2 then tens2aux[i] =  tonumber(token); end
	      j = j+1;
	  end
i = i+1;
end

-- require './lib/sort_two_arrays_from_first.lua'
-- tens1, tens2 =  sort_two_arrays_from_first(tens1aux, tens2aux)

print('#tens1aux ', #tens1aux);



tens1 = torch.Tensor(#tens1aux);
tens2  = torch.Tensor(#tens1aux);

for d=1, #tens1aux do
  tens1 = tens1aux[d];
  tens2 = tens2aux[d];
end


printRoc = false
fileRoc = 'fileprova.txt'
AucComputer(tens1, tens2, #tens1aux, printRoc, fileRoc)


--[[
flagAnn = false -- dice se siamo arrivati alle annotazioni
-- idea generale: lista di righe (profili genici) di zeri ed uni
gpNum = 0 --numero dei profili genici
-- gene_profile = torch.Tensor(#features);
gene_profile = {};
for k,v in pairs(lines) do
    -- lettura zeri ed uni delle annotazioni
    if string.match(v,'annotations:') then flagAnn = true; end
    
    if flagAnn == true then

    gA  =0;
      for token in string.gmatch(v, "[^%s]+") do
	--print(tonumber(token));
	gene_profile[gA] =  tonumber(token);
	 gA=gA+1;
      end
    annotations[gpNum] = gene_profile;
    gpNum = gpNum + 1
    -- print(gene_profile);
    end
end

for i=0,#genes-1 do
   print('gene_profile[' .. i .. ']',  gene_profile[i]);
end
--print(annotations[9]);	

-- for i=0,#genes-1 do
--   print('genes[' .. i .. ']',  genes[i]);
-- end
-- 
-- for i=0,#features-1 do
--   print('features[' .. i .. ']', features[i]);
-- end
-- 
-- print('#genes', #genes);
-- print('#features', #features);]]
