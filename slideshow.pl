#!c:/Perl/bin/perl.exe

use strict;

MAIN:
   DisplayPage();

sub DisplayPage
   {
   print Template("preamble"  );
   print Template("head"      );
   print Template("header"    );
   print Template("frontpage");
   map {DisplaySession($_)} ParseSessionData();
   print Template("backpage");
   print Template("end"       );
   }

sub DisplaySession
   {
   my ($session) = @_;

   return unless gv($session->{"I"});
   print Template("sessiontop", sessionid => gv($session->{"I"}),
                                title     => gv($session->{"T"}),
                                presenter => gv($session->{"P"}));
   print Template("sessionnotesstart");
   map {print Template("sessionnote", note => $_)} @{$session->{notes}};
   print Template("sessionnotesend");
   map {print Template("sessionlink", label=>$_->{label}, url=>$_->{url})} @{$session->{links}};
   print Template("sessionbottom");
   }

sub ParseSessionData
   {
   my @session_data = split ("\n", Template("sessiondata"));
   my (@sessions, $session, $label, $url);
   foreach my $line (@session_data)
      {
      chomp $line;
      my ($linetype, $content) = $line =~ /^(.):(.*)$/;
      ($linetype, $content) = ("notes", $line) if !$linetype;
      
      push(@sessions, $session) if ($linetype eq "I"); # id triggers new session
      $session = {}             if ($linetype eq "I");
      ($label, $url) = split('\|', $content)                 if ($linetype eq "L");
      push (@{$session->{links}}, {label=>$label,url=>$url}) if ($linetype eq "L");
      push (@{$session->{$linetype}}, $content);
      }
   push @sessions, $session;
   return @sessions;
   }   
   
sub gv # get first array value
   {
   my ($arrayref) = @_;
   return $arrayref && length @{$arrayref} ? @{$arrayref}[0] : "";
   }   

###############################################################################

my $TEMPLATES; # (localized global for GetTemplate)

sub Template
   {
   my ($template_name, %params) = @_;

   _InitTemplates() unless $TEMPLATES;
   my $template_data = $TEMPLATES->{$template_name};
   $template_data =~ s{\$(\w+)}{exists $params{$1} ? $params{$1} : "\$$1"}gei;
   return $template_data;
   }

sub _InitTemplates
   {
   my $key = "nada";
   while (my $line = <DATA>)
      {
      my ($section) = $line =~ /^#(\S+)/;
      $key = $section || $key;
      $TEMPLATES->{$key} = ""      if $section;
      $TEMPLATES->{$key} .= $line  if !$section;
      }
   }

__END__
#preamble
Content-type: text/html

#head
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
   <head>
      <title>mix10 notes</title>
      <meta http-equiv="content-type" content="text/html;charset=utf-8" />
      <link href="/static/screen.css" rel="stylesheet" type="text/css" />
      <link href="/static/style.css"  rel="stylesheet" type="text/css" />
      <script type="text/javascript" src="/static/jquery-1.4.2.min.js"></script>
      <script type="text/javascript" src="static/slideshow.js"></script>
   </head>
#header
   <body>
   <div class="container">
      <div id="header" class="clearfix">
         <a href="/"><h1 class="branding">Mix10</h1></a>
         <p class="intro">Craig's Notes from the Mix10 conference</p>
       </div>
   </div>
   <!-- focusgrabber keeps the focus outline from showing in the navbar -->
   <input type="text" id="focusgrabber" name="focusgrabber" />
#end
   <div class="nav"> </div>
   </body>
</html>
#sessiontop
   <div class="session" id="$sessionid">
      <div class="sessionid"> <a href="http://live.visitmix.com/MIX10/Sessions/$sessionid">$sessionid</a> </div>
      <div class="title"    > $title     </div>
      <div class="presenter"> $presenter </div>
#sessionnotesstart
      <ul class="notes">
#sessionnote
         <li>$note</li>
#sessionnotesend
      </ul>
#sessionlink
      <a href="$url">$label</a><br />
#sessionbottom
   </div>
#frontpage
   <div class="frontpage session" id="frontpage">
      <h2>My notes from the Mix10 conference</h2>
      <a href="http://live.visitmix.com/">Mix10 Home Page</a> <br />
      <a href="http://live.visitmix.com/Videos">Mix10 Video's and Slides</a> <br />
   </div>
#backpage
   <div class="backpage session" id="backpage">
      <h2>The end</h2>
   </div>
#sessiondata
I:WKSP01
T:HTML5 Now: The Future of Web Markup Today
P:Molly Holzschlag
L:Link|http://www.molly.com/
   The Wet Working Group, the W3C and the genesis of HTML5
   Implementations trump standards
   HTML5 as an umbrella term vs actual spec
   HTML5 support for past specs
   HTML5 Defining Browser Behavior (errors)
   HTML5 Semantic markup
   XHTML standards body shelved - mime types and the real world
   XHTML support in thml5
   application/xhtml+xml and application/xml but not text/xml (a moving target)
   media tags, canvas, svg, worker threads, local storage, file upload
I:CL07
T:Microsoft Silverlight 4 Overview: What's in Store for Silverlight 4?
P:Keith Smith
L:Video|http://ecn.channel9.msdn.com/o9/mix/10/wmv/CL07.wmv
   Silverlite as an app framework (no browser)
   Silverlight on windows mobile
   Silverlight in Visual Studio
   Silverlight in Expression Blend
   Silverlite 60% market penetration (yeah sure)
I:EX14
T:Understanding the Model-View-ViewModel Pattern
P:Laurent Bugnion
L:Slides|http://ecn.channel9.msdn.com/o9/mix/10/pptx/EX14.pptx
   The MVC Pattern
   The MVC Pattern with Passive Views
   The ViewModel Pattern
   Blendability (oh brother!)
   Example: Converting a project built in Viaual Studio to work in Expression Blend
   Expression Blend stuff
I:EX02
T:The Mono Project
P:Miguel de Icaza
L:Slides|http://ecn.channel9.msdn.com/o9/mix/10/pptx/EX02.pptx
   Mono support for .NET API's
   Moonlight (Silverlight on Mono)
   CLR rewrite to handle platforms
   MonoTouch(iPhone), MonoDroid, MonoMac
   MonoDroid coming soon (not an Android fan)
   Mono challenges - no r/w/e page frames on some platforms
I:EX22
T:Six Things Every jQuery Developer Must Know
P:Elijah Manor
L:Video|http://ecn.channel9.msdn.com/o9/mix/10/wmv/EX22.wmv
   .proxy() setting 'this' -or- call as method
   Wrapping DOM elements in $, unwrapping with .get(), etc...
   Misc selectors and things outside CSS3 spec, selector context, basic stuff...
   Custom selectors: $.expr[";"].mySelector = fn(element,index,metadata,state){} and $("div:mySelector")
   FireQuery Plugin - shows .data (!)
   Importance of .data (ie vs others), storing object, etc...
   Similie jquery plugin
   JQuery selector playgroung web page
   SelectorGadget and Bookmarklet plugins
   preventDefault vs stopPropagation vs return false
   $().bind("click dblclick") as shortcut to .click() and .dblclick()
   Google closure compiler
   .delegate and .undelegate better than live
   YSlow firebug add-on
   Google page speed firebug addon
I:CL28
T:In-Depth Look at Internet Explorer 9
P:Ted Johnson, John Hrvatin
L:Slides|http://ecn.channel9.msdn.com/o9/mix/10/pptx/CL28.pptx
   Charts of the IE engine (DOM->Layout->Display Tree (z-order!))
   HTML5 support & mime types
   JS compatibility (compatible events!)
   New js engine 
   New graphics engine
   Imbedded SVG
   Z-Order issues fixed (mostly - still some issues with activex controls)
   (No worker threads, Local storage, etc.. yet)
I:NONE
T:none (tue 3:00 in the commons)
P:nobody   
   Silverlight and .net library access
   Click-Once and priviledge elevation
I:EX36
T:How jQuery Makes Hard Things Simple
P:John Resig
   $('html...', {click: fn, id:"foo", ...}) and future extensions
   Fragment caching and attributes in html
   .end()
   .data implementation
   .data("events") (internal use)
   Event namespacing: $("").bind("focus.myPlugin, fn) -and- .unbind(".myPlugin") trigger(...)
   Custom events .bind("foo.bar") .bind("foo.baz") .trigger("foo")
   Special events ...
   Event delegation $("table").delegate("td", "hover", fn);
   .proxy() (see othe js session)
   Sizzle engine and extensions (see other js session)
   $().load("url", "h2") elegent shortcut
   Jquery UI
   Jquery grid
   IE6 legacy
I:CL30
T:Building Innovative Windows Client Software
P:Tim Huckaby, Scott Hanselman, Scott Stanfield, Tim Sneath, Dave Wolf
L:Slides|http://ecn.channel9.msdn.com/o9/mix/10/pptx/CL30.pptx
   Largely useless panel talk
   Windows history, ui design specs
   New stuff today
   "I can't make a phone call!"
   Browser restrictions led to innovation
   blah blah blah
I:EX17
T:IronRuby for the .NET Developer
P:Cory Foy
L:Slides|http://ecn.channel9.msdn.com/o9/mix/10/pptx/EX17.pptx
   Challenges getting a Dynamic language running on the CLR
   Examples in ruby in mono
   Motivation: some introduction to dynamic ruby for the C# developres
   Interesting ruby examples
   DLR on the CLR "dynamic keyword in C#"
   Performance Characteristics
I:FT09
T:Pumping "Iron" on the Web: IronRuby and IronPython
P:Jimmy Schementi
L:Slides|http://ecn.channel9.msdn.com/o9/mix/10/pptx/FT09.pptx
   Challenges getting a Dynamic language running on the CLR...
   Why Dynamic languages are relevent to .NET developers
   Some Language Intro to C# developers
   cucumber test env
   Ironruby.net/Download
   httparty gem
I:FTL01
T:Reactive Extensions for JavaScript
P:Erik Meijer
L:Slides|http://ecn.channel9.msdn.com/o9/mix/10/pptx/FTL01.pptx
   De-morgans law
   Analogy to push/pull
   Analogy to sync/async
   Analogy to iEnumerable/iDisposable
   Analogy to Iterator/Observer
   Rx library examples
   Rx in java, C#, javascript
   Rx in js: closures,no thread mgmt, etc....
   Matthew Podwysocki's blog
   RxJS on twitter
#fini