% Convolutional Coded QPSK over AWGN

close all
clear all
clc
SNR_dB = 6; % SNR PER BIT in dB
FRAME_SIZE = 10^3; % FRAME SIZE
NUM_BIT = 1*FRAME_SIZE; % NUMBER OF DATA BITS - OVERALL RATE IS 1
DECODING_DELAY = 20; % DECODING DELAY OF THE VITERBI ALGORITHM

% SNR PARAMETERS - OVERALL RATE IS 1
SNR = 10^(0.1*SNR_dB); % SNR IN LINEAR SCALE
NOISE_VAR_1D = 1*2/(2*SNR); % 1D AWGN NOISE VARIANCE 
NOISE_STD_DEV = sqrt(NOISE_VAR_1D); % NOISE STANDARD DEVIATION
%--------------------------------------------------------------------------
% GENERATOR polynomial of the component encoder
GEN_POLY = ldiv2([1 0 1],[1 1 1],NUM_BIT); % using long division method

tic()

%----            TRANSMITTER      -----------------------------------------
% SOURCE
A = randi([0 1],1,NUM_BIT);

% Convolutional encoder 
B = zeros(1,2*NUM_BIT); % encoder output initialization
B(1:2:end) = A; % systematic bit
temp = mod(conv(GEN_POLY,A),2); 
B(2:2:end) = temp(1:NUM_BIT); % parity bit

% QPSK mapping (according to the set partitioning principles)
MOD_SIG = 1-2*B(1:2:end) + 1i*(1-2*B(2:2:end));

%---------------     CHANNEL      -----------------------------------------
% AWGN
AWGN = normrnd(0,NOISE_STD_DEV,1,FRAME_SIZE)+1i*normrnd(0,NOISE_STD_DEV,1,FRAME_SIZE);

% CHANNEL OUTPUT
CHAN_OP = MOD_SIG + AWGN;

%----------------      RECEIVER  ------------------------------------------
% Branch metrices for the VITERBI ALGORITHM
QPSK_SYM = zeros(4,FRAME_SIZE);
QPSK_SYM(1,:) = (1+1i)*ones(1,FRAME_SIZE);
QPSK_SYM(2,:) = (1-1i)*ones(1,FRAME_SIZE);
QPSK_SYM(3,:) = (-1+1i)*ones(1,FRAME_SIZE);
QPSK_SYM(4,:) = (-1-1i)*ones(1,FRAME_SIZE);

BRANCH_METRIC = zeros(4,FRAME_SIZE);
 BRANCH_METRIC(1,:)=abs(CHAN_OP-QPSK_SYM(1,:)).^2;
 BRANCH_METRIC(2,:)=abs(CHAN_OP-QPSK_SYM(2,:)).^2;
 BRANCH_METRIC(3,:)=abs(CHAN_OP-QPSK_SYM(3,:)).^2;
 BRANCH_METRIC(4,:)=abs(CHAN_OP-QPSK_SYM(4,:)).^2;

 % The Viterbi algorithm
DEC_A = Viterbi_alg(BRANCH_METRIC,FRAME_SIZE,DECODING_DELAY);
 
% BIT ERROR RATE (IGNORING THE LAST TRANSIENT SAMPLES)
BER = nnz(DEC_A-A(1:FRAME_SIZE-DECODING_DELAY))/(FRAME_SIZE-DECODING_DELAY)

toc()
