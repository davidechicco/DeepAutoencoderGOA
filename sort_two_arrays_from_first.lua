


-- let's order ACrate and APrate
function sort_two_arrays_from_first(tens1aux, tens2aux, size)

tens1 = torch.Tensor(size);
tens2  = torch.Tensor(size);

	-- make a copy of ACrate, to sort
	tens1Sorted = {}
	tens2reordered ={}
	for q=1, size do
	  tens1Sorted[q] = tens1aux[q];
	  tens2reordered[q] = -1;
	end
	table.sort(tens1Sorted);

	for i=1, size do
	    for j=1, size do
	      if tens1aux[i]== tens1Sorted[j] then 
		 --  print('The element '.. tens1aux[i] ..' was '..i..'th in the former table and now it is ' .. j ..'th \n');
		  if  tens2reordered[j] == -1 then
		    tens2reordered[j] = tens2aux[i];
		    break;
		  end
	      end
	      -- print('j '..j .. ' i '..i);
	    end
	end

for p=1,size do
  tens1[p] = tens1Sorted[p]
  tens2[p] = tens2reordered[p]
  -- print(tens1[p] .. ' '.. tens2[p]);
end

return tens1, tens2

end

-- let's order ACrate and APrate
function sort_three_arrays_from_first(tens1aux, tens2aux, tens3aux, size)

tens1 = torch.Tensor(size);
tens2  = torch.Tensor(size);
tens3  = torch.Tensor(size);

	-- make a copy of ACrate, to sort
	tens1Sorted = {}
	tens2reordered ={}
	tens3reordered ={}
	for q=1, size do
	  tens1Sorted[q] = tens1aux[q];
	  tens2reordered[q] = -1;
	  tens3reordered[q] = -1;
	end
	table.sort(tens1Sorted);

	count = 1
	for i=1, size do
	    for j=1, size do
	      if tens1aux[i]== tens1Sorted[j] then 
		  --print('The element '.. tens1aux[i] ..' was '..i..'th in the former table and now it is ' .. j ..'th \n');
		  
		  if  tens2reordered[j] == -1 then
		    tens2reordered[j] = tens2aux[i];
		    tens3reordered[j] = tens3aux[i];
		    break;
		  end
	      end
	      -- print('j '..j .. ' i '..i);
	    end
	end

for p=1,size do
  tens1[p] = tens1Sorted[p]
  tens2[p] = tens2reordered[p]
  tens3[p] = tens3reordered[p]
   print(p .. ') '..tens1[p] .. ' '.. tens2[p] .. ' '.. tens3[p]);
end

return tens1, tens2, tens3

end