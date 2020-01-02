#!/afs/athena/contrib/perl/p

$quiet = 0;
$force = 0;
$domodes = 0;
$doowner = 0;
$nodstrules = 0;
$nosrcrules = 0;
@regexps = ();
$linkprefix = undef;

while ($_ = $ARGV[0], /^-/) {
    shift;
    /^-s$/ && ((@ARGV > 0) || die "Missing argument to \"-s\" option.\n")
    	&& ($source = $ARGV[0]) && shift && next;
    /^-d$/ && ((@ARGV > 0) || die "Missing argument to \"-d\" option.\n")
    	&& ($dest = $ARGV[0]) && shift && next;
    /^-a$/ && ((@ARGV > 0) || die "Missing argument to \"-a\" option.\n")
	&& ($rrulefile = $ARGV[0]) && shift && next;
    /^-srules$/ && ((@ARGV > 0) || die "Missing argument to \"-srules\" option.\n")
	&& ($srulefile = $ARGV[0]) && shift && next;
    /^-q$/ && (++$quiet) && next;
    /^-f$/ && (++$force) && next;
    /^-nodstrules$/ && (++$nodstrules) && next;
    /^-nosrcrules$/ && (++$nosrcrules) && next;
    /^-modes$/ && (++$domodes) && next;
    /^-owner$/ && (++$doowner) && next;
    die "Unknown option \"$_\".\n";
}

defined($source) || die "No source directory specified.\n";
defined($dest) || die "No destination directory specified.\n";

(-d $source) || die "Couldn't find $source: $!.\n";
(-d $dest) || mkdir($dest, 0777) || die "Couldn't mkdir $dest: $!\n";

$source .= "/"; $source =~ s,//$,/,;
$dest .= "/"; $dest =~ s,//$,/,;

if ($source !~ m,^/,) {
#    local($sourcepwd);
    local($destpwd);
    local($cwd);
#    local($qsource);
    local($qdest, $qcwd);
    local($slashcount);

#    ($qsource = $source) =~ s/(\W)/\\$1/g;
    ($qdest = $dest) =~ s/(\W)/\\$1/g;

#    open(PWD, "(cd $qsource; pwd)|");
#    chop ($sourcepwd = <PWD>);
#    close(PWD);
#    if ($?) {
#	die "Couldn't pwd in source directory $source.\n";
#    }

    open(PWD, "(cd $qdest; pwd)|");
    chop ($destpwd = <PWD>);
    close(PWD);
    if ($?) {
	die "Couldn't pwd in destination directory $dest.\n";
    }

    open(PWD, "pwd|");
    chop ($cwd = <PWD>);
    close(PWD);
    if ($?) {
	die "Couldn't pwd in current directory.\n";
    }

    ($qcwd = $cwd) =~ s/(\W)/\\$1/g;

    if ($destpwd !~ s/^$qcwd//) {
	die "Destination directory $dest is not subdirectory\n\tof current directory $cwd.\n";
    }

    $slashcount = ($destpwd =~ tr,/,/,);
    
    $linkprefix = "";

    for (2..$slashcount) {
	$linkprefix .= "../";
    }
}

if (defined($rrulefile)) {
    @regexps = &parse_rconf($rrulefile, $source, $dest);
    print STDERR "Error in $rrulefile.\n" if (! @regexps);
}

if (defined($srulefile)) {
    local(@newregexps) = do "$srulefile";
    print STDERR "Error in $srulefile.\n" if (! @newregexps);
    unshift(@regexps, @newregexps);
}

sub remove {
    local($filename) = $_[0];
    local(*RMDIR, @RMDIRENTRIES);
    local($status) = 1;

    print "Removing $filename.\n" if (! $quiet);

    if (! unlink("$filename")) {
	if (-d "$filename") {
	    if (opendir(RMDIR, $filename)) {
		print "Recursively removing $filename.\n" if (! $quiet);
		@RMDIRENTRIES = readdir(RMDIR);
		foreach $entry (@RMDIRENTRIES) {
		    # No messages about subfiles being removed
		    local($quiet) = 1;
		    $status &= &remove("$filename/$entry")
			if (! (($entry eq ".") || ($entry eq "..")));
		}
		closedir(RMDIR);
		$status &= rmdir("$filename");
		$status;
	    }
	    else {
		print STDERR "Couldn't opendir($filename): $!.\n";
		0;
	    }
	}
	else {
	    print STDERR "Couldn't unlink($filename): $!.\n";
	    0;
	}
    }
    else {
	1;
    }
}

# I'm using a wrapper around copydirectory, rather than putting the code
# directly in it, because there are so many exit points from the function
# and I don't want to duplicate the code in each of them, nor do I want
# to modify the function to have only one exit point, nor do I want to
# use goto.

sub copydirectory {
    local($retval);
    local($directory) = @_;

    if (defined($linkprefix)) {
	$linkprefix .= "../";
    }
    $retval = &_copydirectory(@_);
    if (defined($linkprefix)) {
	$linkprefix =~ s/...//;
    }
    $retval;
}

sub _copydirectory {
    local($filename) = $_[0];
    local(@DIRENTRIES, *DIR, @nstats, @ostats);
    local($doit) = 0;
    local(@oldregexps) = @regexps;
    local(@regexps) = @oldregexps;
    local(%destfiles) = ();
    local($slashname, $entry);

    if ($filename eq "") {
	$slashname = "";
    }
    else {
	$slashname = "$filename/";
    }

    if (! (@nstats = lstat("$source$filename"))) {
    	print STDERR "Couldn't lstat($source$filename): $!.\n";
    	return 0;
    }

    if (! $nosrcrules) {
	if (-e "$source$slashname.sconf") {
	    local(@newregexps) = do "$source$filename/.sconf";
	    print STDERR "Error in $source$filename/.sconf.\n" 
		if (! @newregexps);
	    unshift(@regexps, @newregexps);
	}
	elsif (-e "$source$slashname.rconf") {
	    local(@newregexps) = &parse_rconf("$source$filename/.rconf",
					      "$source$filename",
					      "$dest$filename");
	    print STDERR "Error in $source$filename/.rconf.\n" 
		if (! @newregexps);
	    unshift(@regexps, @newregexps);
	}
    }

    if (@ostats = lstat("$dest$filename")) {
    	if (! -d _) {
    	    if ($force) {
    	    	&remove("$dest$filename");
    	    	$doit++;
    	    }
    	    else {
    	    	print STDERR "Couldn't mkdir($dest$filename): Exists and isn't a directory.\n";
    	    	return 0;
    	    }
    	}
	else {
	    if (! opendir(DIR, "$dest$filename")) {
		print STDERR "Couldn't opendir($dest$filename): $!.\n";
	    }
	    else {
		if (! (@DIRENTRIES = readdir(DIR))) {
		    closedir(DIR);
		    print STDERR "Couldn't readdir($dest$filename): $!.\n";
		}
		else {
		    closedir(DIR);
		    foreach $entry (@DIRENTRIES) {
			$destfiles{$entry}++;
		    }
		}
	    }
	    if (! $nodstrules) {
		if (-e "$dest$slashname.sconf.local") {
		    local(@newregexps) = do "$dest$slashname.sconf.local";
		    print STDERR 
			"Error reading $dest$slashname.sconf.local: $!.\n"
			if (! @newregexps);
		    unshift(@regexps, @newregexps);
		}
		elsif (-e "$dest$slashname.rconf.local") {
		    local(@newregexps) = 
			&parse_rconf("$dest$slashname.rconf.local",
				     "$source$filename",
				     "$dest$filename");
		    print STDERR 
			"Error reading $dest$slashname.rconf.local.\n"
			    if (! @newregexps);
		    unshift(@regexps, @newregexps);
		}
	    }
  	    if (! &fixmodes("$filename", 0, *ostats, *nstats)) {
    	    	return 0;
    	    }
    	}
    }
    else {
    	$doit++;
    }
    if ($doit) {
    	if (! mkdir("$dest$filename", 0777)) {
    	    print STDERR "Couldn't mkdir($dest$filename): $!.\n";
    	    return 0;
    	}
    	if (! &fixmodes("$filename", 1, *ostats, *nstats)) {
    	    return 0;
    	}
    	print "mkdir($dest$filename)\n" if (! $quiet);
    }
    if (! opendir(DIR, "$source$filename")) {
    	print STDERR "Couldn't opendir($source$filename): $!.\n";
    	return 0;
    }
    if (! (@DIRENTRIES = readdir(DIR))) {
    	print STDERR "Couldn't readdir($source$filename): $!.\n";
    	closedir(DIR);
    	return 0;
    }
    closedir(DIR);
    foreach $entry (@DIRENTRIES) {
	$destfiles{$entry} = undef;
    	&doit("$slashname$entry", 0) if (! (($entry eq ".") || 
					    ($entry eq "..")));
    }
    foreach $entry (keys(%destfiles)) {
	&doit("$slashname$entry", 1) if ($destfiles{$entry} &&
					 (! (($entry eq ".") ||
					     ($entry eq ".."))));
    }
    if (utime($nstats[8], $nstats[9], "$dest$filename") < 1) {
    	print STDERR "Couldn't ustat($nstats[8], $nstats[9], $dest$filename): $!.\n";
    	return 0;
    }
    1;
}

sub linkany {
    local($filename) = $_[0];
    local($doit) = 0;

    if (lstat("$dest$filename")) {
    	if (! -l _) {
    	    if ($force) {
    	    	&remove("$dest$filename");
    	    	$doit++;
    	    }
    	    else {
    	    	print STDERR "Couldn't symlink($dest$filename): Exists and isn't a symlink.\n";
    	    	return 0;
    	    }
    	}
    	else {
            local($link) = readlink("$dest$filename");
            if (! $link) {
                print STDERR "Couldn't readlink($dest$filename): $!.\n";
                return 0;
            }
            if ($link ne "$linkprefix$source$filename") {
		&remove("$dest$filename");
		$doit++;
	    }
    	}
    }
    else {
    	$doit++;
    }
    if ($doit) {
    	if (! symlink("$linkprefix$source$filename", "$dest$filename")) {
    	    print STDERR "Couldn't symlink($dest$filename, $source$filename): $!.\n";
    	    return 0;
    	}
    	else {
    	    print "symlink($dest$filename, $linkprefix$source$filename)\n" if (! $quiet);
    	}
    }
    1;
}

sub copyfile {
    local($filename) = $_[0];
    local(@nstat, @ostat);
    local($doit) = 0;

    if (@ostat = lstat("$dest$filename")) {
    	if (! -f _) {
    	    if ($force) {
    	    	&remove("$dest$filename");
    	    	$doit++;
    	    }
    	    else {
    	    	print STDERR "Couldn't copyfile($dest$filename): Exists and is not regular file.\n";
    	    	return 0;
    	    }
    	}
    	else {
    	    if (! (@nstat = lstat("$source$filename"))) {
    	    	print STDERR "Couldn't lstat($source$filename): $!.\n";
    	    	return 0;
    	    }
    	    if (($ostat[9] > $nstat[9]) && (! $force)) {
    	    	print STDERR "Couldn't copyfile($dest$filename): Exists and is newer than $source$filename.\n";
    	    	return 0;
    	    }
    	    if (($ostat[7] != $nstat[7]) || ($ostat[9] < $nstat[9])) {
    	    	&remove("$dest$filename");
    	    	$doit++;
    	    }
    	    else {
    	    	if (! &fixmodes("$filename", 0, *ostat, *nstat)) {
    	    	    return 0;
    	    	}
    	    }
    	}
    }
    else {
    	$doit++;
    	if (! (defined(@nstat) || (@nstat = lstat("$source$filename")))) {
    	    print STDERR "Couldn't lstat($source$filename): $!.\n";
    	    return 0;
    	}
    }
    if ($doit) {
    	if (! &real_copyfile("$filename")) {
    	    print STDERR "Couldn't copy to $dest$filename: $!.\n";
    	    return 0;
    	}
    	print "copyfile($source$filename, $dest$filename)\n" if (! $quiet);
    	if (! &fixmodes("$filename", 1, *ostat, *nstat)) {
    	    return 0;
    	}
    }
    1;
}

sub real_copyfile {
    local($filename) = $_[0];
    local(@stats, $readdata, *COPYFILE);

    if (! open(COPYFILE, "$source$filename")) {
    	return 0;
    }
    binmode(COPYFILE);
    if (! (@stats = stat(COPYFILE))) {
    	return 0;
    }
    if (sysread(COPYFILE, $readdata, $stats[7]) < $stats[7]) {
    	close(COPYFILE);
    	return 0;
    }
    close(COPYFILE);
    if (! open(COPYFILE, ">$dest$filename")) {
    	return 0;
    }
    if (syswrite(COPYFILE, $readdata, $stats[7]) < $stats[7]) {
    	close(COPYFILE);
    	return 0;
    }
    close(COPYFILE);
    if (utime($stats[8], $stats[9], "$dest$filename") < 1) {
    	return 0;
    }
    1;
}

sub copylink {
    local($filename) = $_[0];
    local($olink, $nlink);
    local($doit) = 0;

    if (! ($nlink = readlink("$source$filename"))) {
    	print STDERR "Couldn't readlinke($source$filename): $!.\n";
    	return 0;
    }
    if (lstat("$dest$filename")) {
    	if (! -l _) {
    	    if ($force) {
    	    	&remove("$dest$filename");
    	    	$doit++;
    	    }
    	    else {
    	    	print STDERR "Couldn't symlink($dest$filename): Exists and is not a symlink.\n";
    	    	return 0;
    	    }
    	}
    	else {
    	    if (! ($olink = readlink("$dest$filename"))) {
    	    	print STDERR "Couldn't readlink($dest$filename): $!.\n";
    	    	return 0;
    	    }
    	    if ($olink ne $nlink) {
    	    	&remove("$dest$filename");
    	    	$doit++;
    	    }
    	}
    }
    else {
    	$doit++;
    }
    if ($doit) {
    	if (! symlink("$nlink", "$dest$filename")) {
    	    print STDERR "Couldn't symlink($nlink, $dest$filename): $!.\n";
    	    return 0;
    	}
    	else {
    	    print "symlink($nlink, $dest$filename)\n" if (! $quiet);
    	}
    }
    1;
}

sub deleteany {
    local($filename) = $_[0];

    &remove("$dest$filename") if (-e "$dest$filename");
}

sub DO_COPY 	    {(1<<0);}
sub DO_LINK 	    {(1<<1);}
sub DO_IGNORE 	    {(1<<2);}
sub DO_DELETE	    {(1<<3);}
sub DO_ALL  	    {(&DO_COPY|&DO_LINK|&DO_IGNORE|&DO_DELETE);}
sub ON_DIRECTORY    {(1<<4);}
sub ON_FILE 	    {(1<<5);}
sub ON_LINK 	    {(1<<6);}
sub ON_ALL  	    {(&ON_DIRECTORY|&ON_FILE|&ON_LINK);}
sub DO_FORCE	    {(1<<7);}
sub DO_PERMS        {(1<<8);}

sub doit {
    local($filename, $delete_only) = @_;
    local($filetype, $operationtype, $reg);
    local($workfile);
    local($oldsource);

    if ($delete_only) {
	$workfile = "$dest$filename";
    }
    else {
	$workfile = "$source$filename";
    }

    if (! lstat("$workfile")) {
    	print STDERR "Couldn't lstat($workfile): $!.\n";
    	return 0;
    }
    $_ = "$filename";
    for ($i = $[; $i < @regexps; $i += 2) {
    	if (/${regexps[$i]}/) {
    	    if (-l _) {
    	    	$filetype = &ON_LINK;
    	    }
    	    elsif (-d _) {
    	    	$filetype = &ON_DIRECTORY;
    	    }
    	    elsif (-f _) {
    	    	$filetype = &ON_FILE;
    	    }
    	    else {
    	    	print STDERR "Unknown file type for $workfile.\n";
    	    	return 0;
    	    }
    	    if ($regexps[$i + 1] & $filetype) {
    	    	$operationtype = $regexps[$i + 1] & &DO_ALL;
		local($force) = 1 if ($regexps[$i + 1] & &DO_FORCE);
		local($doowner, $domodes) = (1, 1)
		    if ($regexps[$i + 1] & &DO_PERMS);
    	    	if ($operationtype == &DO_IGNORE) {
    	    	    return 1;
    	    	}
    	    	elsif ($operationtype == &DO_LINK) {
		    return 1 if ($delete_only);
    	    	    return &linkany("$filename");
    	    	}
		elsif ($operationtype == &DO_DELETE) {
		    return &deleteany("$filename");
		}
    	    	elsif ($operationtype == &DO_COPY) {
		    return 1 if ($delete_only);
    	    	    if ($filetype == &ON_LINK) {
    	    	    	return &copylink("$filename");
    	    	    }
    	    	    elsif ($filetype == &ON_DIRECTORY) {
    	    	    	return &copydirectory("$filename");
    	    	    }
    	    	    else {
    	    	    	return &copyfile("$filename");
    	    	    }
    	    	}
    	    }
    	}
    }
    1;
}

sub fixmodes {
    local($filename, $forcemodes, *ostats, *nstats) = @_;
    local($perm);

    if (($domodes && (($ostats[2] & 07777) != ($nstats[2] & 07777))) || $forcemodes) {
    	$perm = $nstats[2] & 07777;
	if (chmod($perm, "$dest$filename") < 1) {
	    print STDERR "Couldn't chmod($dest$filename): $!.\n";
	    return 0;
	}
	else {
	    print "chmod($perm, $dest$filename)\n" if (! ($quiet || $forcemodes));
	}
    }
    if ($doowner) {
	if (($ostats[4] != $nstats[4]) || ($ostats[5] != $nstats[5])) {
	    if (chown($nstats[4], $nstats[5], "$dest$filename") < 1) {
		print STDERR "Couldn't chown($dest$filename): $!.\n";
		return 0;
	    }
    	    else {
    	    	print "chown($nstats[4], $nstats[5], $dest$filename)\n" if (! $quiet);
    	    }
	}
    }
    1;
}

# Not doing chase yet
# Not supporting file types b, c or s yet
sub parse_rconf {
    local($filename, $source, $dest) = @_;
    local(@regexps) = ();

    if (! open(RCONF, "$filename")) {
	print STDERR "Couldn't open $filename: $!.\n";
	return @regexps;
    }

    while (<RCONF>) {
	chop;
	if (/^(copy|link|ignore|delete)/) {
	    local(@fields, $name, $typestring, @typestrings,
		  $operation);
	    @fields = split;
	    if ($fields[0] eq "copy") {
		$operation = &DO_COPY;
	    }
	    elsif ($fields[0] eq "link") {
		$operation = &DO_LINK;
	    }
	    elsif ($fields[0] eq "ignore") {
		$operation = &DO_IGNORE;
	    }
	    elsif ($fields[0] eq "delete") {
		$operation = &DO_DELETE;
	    }
	    else {
		die "Unknown operation type \"$fields[0]\" in parse_rconf";
	    }
	    shift(@fields);
	    if ($fields[0] =~ /;/) {
		$name = $`;
		@typestrings = split(//, $');
		foreach $typestring (@typestrings) {
		    if ($typestring eq "r") {
			$operation |= &ON_FILE;
		    }
		    elsif ($typestring eq "l") {
			$operation |= &ON_LINK;
		    }
		    elsif ($typestring eq "d") {
			$operation |= &ON_DIRECTORY;
		    }
		    elsif ($typestring =~ /^[bcs]$/) {
			print STDERR "Warning: ignoring rconf file type \"$typestring\" on command \"$_\".\n";
		    }
		    else {
			die "Unknown file type \"$typestring\" in parse_conf";
		    }
		}
	    }
	    else {
		$name = $fields[0];
		$operation |= &ON_ALL;
	    }
	    shift(@fields);
	    while ($fields[0] =~ /^-/) {
		if ($fields[0] eq "-p") {
		    $operation |= &DO_PERMS;
		}
		elsif ($fields[0] eq "-f") {
		    $operation |= &DO_FORCE;
		}
		else {
		    print STDERR
	  "Warning: ignoring option \"$fields[0]\" to rconf command \"$_\".\n";
		}
		shift(@fields);
	    }
	    # Quote special characters
	    $name = "$name";
	    # Quote special characters
	    $name =~ s/(\W)/\\$1/g;
	    # Change asterisk to .*;
	    $name =~ s/\\\*/.*/g;
	    unshift(@regexps, "^$name$", $operation);
	}
	elsif (/^(chase|map)/) {
	    print STDERR "Warning: ignoring rconf command \"$1\".\n";
	    next;
	}
	elsif (/^\s*$/) {
	    next;		# blank lines
	}
	elsif (/^\s*;/) {
	    next;		# comment
	}
	else {
	    print STDERR "Warning: unknown rconf command \"$_\".\n";
	}
    }

    close(RCONF);
    return @regexps;
}

&copydirectory("");
