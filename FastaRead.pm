
package FastaRead ;
use strict ;

sub new {
	my ( $class, $fn ) = @_ ;
	my $fh ;
	if ( $fn eq "-" ) {
		$fh= *STDIN ;
	} else {
		open $fh, "<$fn" or die "Cannot open $fn" ;
	}
	my $self = {} ;
	$self->{file} = $fh ;
	$self->{lastheader} = <$fh> ;
	$self->{eof} = 0 ;
	chomp $self->{lastheader} ;
	bless ( $self, $class ) ;
	return $self ;
}

sub eof {
	return $_[0]->{eof} ;
}

sub nextfa {
	my ( $self ) = @_ ;
	return 0 if( $self->{eof} ) ;
	my $seq = "" ;
	my $fh = $self->{file} ;
	while (<$fh>) {
		chomp ;
		unless ( /^>/ ) {
			$seq .= $_ ;
		} else {
			my $header = $self->{lastheader} ;
			$self->{lastheader} = $_ ;
			return ( $header, $seq ) ;
		}
	}
	$self->{eof} = 1 ;
	return ( $self->{lastheader}, $seq ) ;
}

1;
