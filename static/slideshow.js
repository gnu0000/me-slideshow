//
// Slideshow

$(function () {new PageControl()});

function PageControl () {
   var self = this;

   this.Init = function () {
      self.ballimg1 = "/static/ball.gray.png" // navigation dingbat: non selected 
      self.ballimg2 = "/static/ball.red.png"  // navigation dingbat: selected
      self.HideAll();
      self.AddNavigation();
      self.ShowPage("frontpage")
   }

   this.AddNavigation = function () {
      var link = $('<a href="javascript:void(0)" ><img src="'+ self.ballimg1 +'" /></a>');
      $(".session").each(function() {
         var id = $(this).attr("id");
         $(".nav").append(link.clone().attr("alt", id).click(function(e){self.ShowPage(id)}));
      });
      $(document).keydown(this.HandleKeyDown);
   }

   this.HideAll = function () {
      $(".session").addClass("invisible");
   }

   this.ShowPage = function (pageid) {
      self.HideAll();
      $("#" + pageid).removeClass("invisible");
      $('img[src="'+ self.ballimg2 +'"]').attr("src", self.ballimg1);
      $("a:[alt='"+pageid+"']").find("img").attr("src", self.ballimg2);
      $('#focusgrabber').focus();
   };

   this.HandleKeyDown = function (e) {
      if (e.which == 36) self.ShowFirst();
      if (e.which == 35) self.ShowLast();
      if (e.which == 39) self.ShowNext();
      if (e.which == 37) self.ShowPrev();
   };

   this.ShowNext = function() {
      var link = $('img[src="'+ self.ballimg2 +'"]').parent().next();
      if (link.length) return self.ShowPage(link.attr("alt"));
      self.ShowFirst();
   };

   this.ShowPrev = function() {
      var link = $('img[src="'+ self.ballimg2 +'"]').parent().prev();
      if (link.length) return self.ShowPage(link.attr("alt"));
      self.ShowLast();
   };

   this.ShowFirst = function() {
      self.ShowPage($('.nav a:first').attr("alt"));
   };

   this.ShowLast = function() {
      self.ShowPage($('.nav a:last').attr("alt"));
   };

   this.Init();
};

