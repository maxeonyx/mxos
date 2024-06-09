{ ... }: {
  programs.fish = {
    enable = true;
    
    functions = {
    	git-info = {
    	  body = builtins.readFile ./fish/git-info.fish;
    	};
    };
    
  };
}
