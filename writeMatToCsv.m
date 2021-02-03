function writeMatToCsv(mat, fileName)
% Write matrix to file, made for MATLAB Coder compatibility
% Overwrites file if it already exists
% mat - matrix (up to 2-dimensional) to write to csv
% fileName - file to write to (including extension)

fileID = fopen(fileName, 'w');
for i = 1:size(mat, 1)
    for j = 1:size(mat, 2)
        fprintf(fileID, '%.10g', mat(i, j));
        if j ~= size(mat, 2)
            fprintf(fileID, ',');
        end
    end
    if i ~= size(mat, 1)
        fprintf(fileID, '\r\n');
    end
end
fclose(fileID);
end

