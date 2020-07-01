system"S ",string `int$.z.p mod 0Wi-1;
i:til 9;
k:i cross i;
b:k!count[k]#" ";
//to display 
showBoard:{9 cut value x};

//create random board
createBoard:{
	{
		hzVert:(0,/:til y;til[y],\:0);
		emptyKeys:where null x;
		possCo:raze emptyKeys+\:hzVert;
		.[x;;:;first string y] 1?possCo where all each possCo in emptyKeys
		}/[b;x]
	}
ships:2 3 4 5;
setUp:{
	//each player has their own board and a target board
	`p2`p1`p2t`p1t set\:b;
	//radomly generate two boards
	`p1 set createBoard ships;
	`p2 set createBoard ships;
	}
//fuction for taking a shot
shot:{@[x;c;:;]"HM" null y c:algo x}

//game tatics
//basic choose at random an empty square
algo1:{1?where null x}
//based on a hit shot neighbouring empty squares
algo2:{
	if[count hits:where "H"=x;
		//if we already have hits lookat all neigbouring squares
		res:raze hits+\:/:(0 1;1 0;0 -1;-1 0);
		//reduce to ones we havent already hit
		res:key[x] inter res except where not null x;
		//if none left do random guess
		if[not count res;:algo1 x];
		//pick one of these at random
		:1?res;
		];
	:algo1 x;
	}	

algo3:{
	//create set of 100 possible boards
 	res:distinct {createBoard 2 3 4 5} each til 100;
	//reduce res down based on where you have misses and potential board has a ship
	res@:where 0=count each (where "M"=x) inter/:where each not null res;
	//if none left do random guess
	if[not count res;:algo1 x];
	//select the co ord that had a ship in it most commonly
	first key desc sum not null res 
	}

algo4:{
	
	}

algo:algo1
gameFinished::any sum[ships]=sum each "H"=(p1t;p2t)

//play game
setUp[];
play:{
	setUp[];
	numMoves:0;
	while[not gameFinished;p1t::shot[p1t;p2];p2t::shot[p2t;p1];numMoves+:1;-1 showBoard[p1t],'"|",/:showBoard[p2t];-1 "--------"];
	numMoves
	}
