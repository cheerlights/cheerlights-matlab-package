function tf = isHex(values)
%ISHEX True for each value that is six hexadecimal digits, with or without a leading "#".

tf = ~cellfun(@isempty, regexp(cellstr(string(values)), "^\s*#?[0-9a-fA-F]{6}\s*$", "once"));
tf = reshape(tf, size(values));
end
