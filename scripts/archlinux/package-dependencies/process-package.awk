# Process the package dependencies of an arch system.

BEGIN {
    printf "---| Software depedency list |--\n"
}
{
    ++cnt;
    package=$0;
    print "Software: ", $package;
    
    printf "Depedencies: \n"
    system("pactree $0")
    
#    cmd=sprintf("pactree --graph %s | dot -Tpng > packages/%s.png", $package, $package);
#    system(cmd);

    printf "======================================\n\n";
}
END {
      print "---| Total packages (", cnt, ") |---\n"      
}