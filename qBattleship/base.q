system"S ",string `int$.z.p mod 0Wi-1;
i:til 9;
k:i cross i;
b:k!count[k]#" ";
9 cut value b;

//create random board
createBoard:{{.[x;;:;first string y] a:1?c where all each in[;k]c:raze (k:where null x)+\:(0,/:til y;til[y],\:0)}/[b;x]}
//each player has their own board and a target board
p2:p1:p2t:p1t:b;
//radomly generate two boards
p1:createBoard ships:2 3 4 5;
p2:createBoard ships;
//fuction for taking a shot
shot:{@[x;c;:;]"HM" null y c:algo x}

//game tatics
algo1:{1?where null x}
res:distinct {createBoard 2 3 4 5} each til 10000 
//the board from res that most closely resembles p1t
//res idesc sum each p1t=/:"HM" null res
//reduce res down to possible boards 
algo2:{
 res@:where 0=count each (where "M"=x) inter/:where each not null res;
//key with most common nulls in re
 first key desc (sum not null res)%count res 
 }
algo:algo2
//play game
gameFinished::any sum[ships]=sum each "H"=(p1t;p2t)
while[not gameFinished;p1t:shot[p1t;p2];p2t:shot[p2t;p1];numMoves+:1]
numMoves
