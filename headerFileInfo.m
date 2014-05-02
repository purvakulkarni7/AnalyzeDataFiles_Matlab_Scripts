function [ImageSize, ByteOrder, Dimensions]=headerFileInfo(header)
% Parses specific information from the header file and presents it on
% screen
% headerFileInfo(header)

if isfield(header,'ImgFileSize')
    ImageSize = [header.ImgFileSize]
end

if isfield(header,'ByteOrder')
        ByteOrder = [header.ByteOrder]
end

if isfield(header,'Dimensions')
        Dimensions = [header.Dimensions]
end



