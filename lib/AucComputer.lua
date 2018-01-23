-- function that takes two tensors and computes the Area Under the Curve
function AucComputer(tens1, tens2, size, printRoc, fileRoc)
	area = 0;
	local fRoc,err;
	if printRoc then fRoc,err = io.open(fileRoc,"w"); fRoc.close(); end
	if printRoc then fRoc,err = io.open(fileRoc,"a"); end
	 -- print ACrate and APrate into the file
	for q=1, size do
	  if printRoc then
	    tens1[q] = round(tens1[q], 3);
	    tens2[q] = round(tens2[q], 3);
	    -- fRoc:write(ACrate .. '\t' .. APrate ..'\t' ..  threshold .. '\n');
	     fRoc:write(tens1[q] .. '\t' .. tens2[q] ..'\n');
	  end  
	  
	  if q>=2 then
	    area = area + ((tens1[q] - tens1[q-1]) * (tens2[q-1] + tens2[q]))/2;
	  end 
	  
	  q = q+1;
	end
	
	-- tens1[size] = tens1[size-1];
	-- tens2[size] = tens2[size-1];
	
	area = round(area*100, 2);
	print('the AUC is ' .. area ..'%');
	require 'gnuplot';
	gnuplot.plot(tens1, tens2, '-');

	if printRoc then  fRoc:close(); end  

	return area
end