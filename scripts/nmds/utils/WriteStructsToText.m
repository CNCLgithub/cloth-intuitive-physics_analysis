function WriteStructsToText(filename,theStructs)
% Open the file
fid = fopen(filename,'wt');

% Get the fieldnames
theFields = fieldnames(theStructs(1));
nFields = length(theFields);
for i = 1:nFields
	fprintf(fid,'%s',theFields{i});
	if (i < nFields)
		fprintf(fid,'\t');
	else
		fprintf(fid,'\n');
	end
end

% Now write each struct's data as a line
nStructs = length(theStructs);
for j = 1:nStructs
	for i = 1:nFields	
		if (ischar(getfield(theStructs(j),theFields{i})))
			fprintf(fid,'%s',getfield(theStructs(j),theFields{i}));
		else
			fprintf(fid,'%g',getfield(theStructs(j),theFields{i}));
		end
		if (i < nFields)
			fprintf(fid,'\t');
		else
			fprintf(fid,'\n');
		end
	end
end

% Close the file.
fclose(fid);
%if (IsOS9)
 %   filetype(filename,'TEXT','XCEL');
%end
