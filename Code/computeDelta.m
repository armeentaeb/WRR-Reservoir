function [delta] = computeDelta(precision,graphModel)
     delta = trace(precision^(-1)-graphModel^(-1))/trace(precision^(-1));
end