let rec to_string l = 
	match l with
	| Node.Expression e -> e
	| Node.Abstraction (l, e) -> "(\\" ^ l ^ "." ^ to_string e ^ ")"
	| Node.Application (l, r) -> "(" ^ to_string l ^ " " ^ to_string r ^ ")"
	| Node.DBExpression e -> string_of_int e
	| Node.DBAbstraction (l) -> "(\\." ^ to_string l ^ ")";;

module MyMap = Map.Make(String);;
let db_map = ref MyMap.empty;;

let rec todb tree level =
	match tree with
	| Node.Application (l, r) -> Node.Application(todb l level, todb r level)
	| Node.Abstraction (l, e) -> if not (MyMap.mem l !db_map) then begin
		db_map := MyMap.add l (level + 1) !db_map;
		let ans = Node.DBAbstraction(todb e (level + 1)) in
		db_map := MyMap.remove l !db_map;
		ans;
		end
	else begin
		let x = MyMap.find l !db_map in
			db_map := MyMap.add l (level + 1) !db_map;
			let ans = Node.DBAbstraction(todb e (level + 1)) in
				db_map := MyMap.add l x !db_map;
				ans
	end;
	| Node.Expression e -> if (MyMap.mem e !db_map) then Node.DBExpression(level - (MyMap.find e !db_map)) else Node.Expression(e);;

let rec fromdb tree level = 
	match tree with
	| Node.Expression e -> tree
	| Node.DBExpression e -> Node.Expression("yubfkohgr" ^ (string_of_int (level - e - 1)))
	| Node.DBAbstraction l -> Node.Abstraction("yubfkohgr" ^ (string_of_int level), fromdb l (level + 1))
	| Node.Application (l, r) -> Node.Application(fromdb l level, fromdb r level);;

let rec level_up tree cur_level up_level = 
	match tree with
	| Node.Expression e -> tree
	| Node.DBExpression e -> if (e >= cur_level) then Node.DBExpression(e + up_level) else tree
	| Node.DBAbstraction l -> Node.DBAbstraction(level_up l (cur_level + 1) up_level)
	| Node.Application (l, r) -> Node.Application(level_up l cur_level up_level, level_up r cur_level up_level);;

let rec do_redex to_tree from_tree level =
	match to_tree with
	| Node.Expression e -> to_tree
	| Node.DBExpression e -> if (e == level) then level_up from_tree 0 level else if (e > level) then Node.DBExpression(e - 1) else to_tree
	| Node.DBAbstraction l -> Node.DBAbstraction(do_redex l from_tree (level + 1))
	| Node.Application (l, r) -> Node.Application(do_redex l from_tree level, do_redex r from_tree level);;

let rec find_redex tree =
	match tree with
	| Node.Expression e -> tree
	| Node.DBExpression e -> tree
	| Node.DBAbstraction l -> Node.DBAbstraction(find_redex l)
	| Node.Application (l, r) -> match l with
								 | Node.DBAbstraction e -> do_redex e r 0
								 | Node.DBExpression e -> Node.Application(l, find_redex r)
								 | Node.Expression e -> Node.Application(l, find_redex r)
								 | Node.Application (l1, r1) -> Node.Application(find_redex l, find_redex r);;

let _ =
        let buf = Buffer.create 1024 in	
        	try
        		while (true) do 
        			Buffer.add_string buf (read_line() ^ " ")
    			done
        	with e ->
            	let buf1 = Lexing.from_string (Buffer.contents buf) in
            	let result = Parser.input Lexer.token buf1 in
            	let cur_tree = ref (todb result 0) in
            	let f = ref true in	
            		let new_tree = ref (!cur_tree) in
            		while (!f) do
            			new_tree := find_redex !cur_tree;
        				if (!new_tree = !cur_tree) then f := false else cur_tree := !new_tree;
                	done;
            	print_endline (to_string (fromdb !cur_tree 0));;