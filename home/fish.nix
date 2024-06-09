{
  programs.fish = {
    enable = true;
    
    functions = {
      git-info = {
        body = ''
          # Check if inside a git repository
          set inside_git_repo (git rev-parse --is-inside-work-tree 2>/dev/null)
          if test "$inside_git_repo" != "true"
              echo "Not inside a Git repository."
              return 1
          end

          # Get the branch, tag, and commit info
          set branch (git rev-parse --abbrev-ref HEAD)
          set tag (git describe --tags --exact-match 2>/dev/null)
          set commit (git rev-parse --short=10 HEAD)

          # Check if the working directory is dirty
          git diff --quiet
          set dirty $status

          # Build the output
          if set --query tag[1]
              # If there's a tag, use it
              set output $tag.$commit
          else if test "$branch" != "HEAD"
              # If on a branch, use the branch name
              set output $branch.$commit
          else
              # If detached head, use the commit hash
              set output $commit
          end

          # If the working directory is dirty, append ".dirty"
          if test $dirty -ne 0
              set output $output.dirty
          end

          # Output the result
          echo $output
        '';
      };
      fish_greeting = {
        body = ''
          date
          echo
        '';
      };
      mkc = {
        body = ''
          mkdir -p $argv[1]
          pushd $argv[1]
        '';
      };
    };
    
  };
}
