= mms2r

  https://github.com/monde/mms2r

== DESCRIPTION

MMS2R by Mike Mondragon
http://mms2r.rubyforge.org/
https://github.com/monde/mms2r
https://github.com/monde/mms2r/issues
http://peepcode.com/products/mms2r-pdf

MMS2R is a library that decodes the parts of an MMS message to disk while
stripping out advertising injected by the mobile carriers.  MMS messages are
multipart email and the carriers often inject branding into these messages.  Use
MMS2R if you want to get at the real user generated content from a MMS without
having to deal with the cruft from the carriers.

If MMS2R is not aware of a particular carrier no extra processing is done to the
MMS other than decoding and consolidating its media.

MMS2R can be used to process any multipart email to conveniently access the
parts the mail is comprised of.

Contact the author to add additional carriers to be processed by the library.
Suggestions and patches appreciated and welcomed!

Corpus of carriers currently processed by MMS2R:

* 1nbox/Idea: 1nbox.net
* 3 Ireland: mms.3ireland.ie
* Alltel: mms.alltel.com
* AT&T/Cingular/Legacy: mms.att.net, mm.att.net, txt.att.net, mmode.com, mms.mycingular.com,
  cingularme.com, mobile.mycingular.com pics.cingularme.com
* Bell Canada: txt.bell.ca
* Bell South / Suncom / SBC Global: bellsouth.net, sbcglobal.net
* Cricket Wireless: mms.mycricket.com
* Dobson/Cellular One: mms.dobson.net
* Helio: mms.myhelio.com
* Hutchison 3G UK Ltd: mms.three.co.uk
* INDOSAT M2: mobile.indosat.net.id
* LUXGSM S.A.: mms.luxgsm.lu
* Maroc Telecom / mms.mobileiam.ma
* MTM South Africa: mms.mtn.co.za
* NetCom (Norway): mms.netcom.no
* Nextel: messaging.nextel.com
* O2 Germany: mms.o2online.de
* O2 UK: mediamessaging.o2.co.uk
* Orange & Regional Oranges: orangemms.net, mmsemail.orange.pl, orange.fr
* PLSPICTURES.COM mms hosting: waw.plspictures.com
* PXT New Zealand: pxt.vodafone.net.nz
* Rogers of Canada: rci.rogers.com
* SaskTel: sasktel.com, sms.sasktel.com, cdma.sasktel.com
* Sprint: pm.sprint.com, messaging.sprintpcs.com, sprintpcs.com
* T-Mobile: tmomail.net, mmsreply.t-mobile.co.uk, tmo.blackberry.net
* TELUS Corporation (Canada): mms.telusmobility.com, msg.telus.com
* U.S. Cellular: mms.uscc.net
* UAE MMS: mms.ae
* Unicel: unicel.com, info2go.com
  (note: mobile number is tucked away in a text/plain part for unicel.com)
* Verizon: vzwpix.com, vtext.com, labwig.net
* Virgin Mobile: vmpix.com, pixmbl.com, vmobl.com, yrmobl.com
* Virgin Mobile of Canada: vmobile.ca
* Vodacom: mms.vodacom4me.co.za

Corpus of smart phones known to MMS2R:
* Apple iPhone variants
* Blackberry / Research In Motion variants
* Casio variants
* Droid variants
* Google / Nexus One variants
* HTC variants (T-Mobile Dash, Sprint HERO)
* LG Electronics variants
* Motorola variants
* Pantech variants
* Qualcom variants
* Samsung variants
* Sprint variants
* UTStarCom variants

As Seen On The Internets - sites known to be using MMS2R in some fashion

* twitpic.com [http://www.twitpic.com/]
* Simplton [http://simplton.com/]
* fanchatter.com [http://www.fanchatter.com/]
* camura.com [http://www.camura.com/]
* eachday.com [http://www.eachday.com/]
* beenup2.com [http://www.beenup2.com/]
* snapmylife.com [http://www.snapmylife.com/]
* email the author to be listed here


== FEATURES

* #default_media and #default_text methods return a File that can be used in
  attachment_fu or Paperclip
* #process supports blocks for enumerating over the content of the MMS
* #process can be made lazy when :process => :lazy is passed to new
* logging is enabled when :logger => your_logger is passed to new
* an mms instance acts like a Mail object, any methods not defined on the
  instance are delegated to it's underlying Mail object
* #device_type? returns a symbol representing a device or smartphone type
  Known smartphones thus far: iPhone, BlackBerry, T-Mobile Dash, Droid,
  Samsung

== BOOKS

MMS2R, Making email useful
http://peepcode.com/products/mms2r-pdf

== SYNOPSIS

  begin
    require 'mms2r'
  rescue LoadError
    require 'rubygems'
    require 'mms2r'
  end

  # required for the example
  require 'fileutils'

  mail = MMS2R::Media.new(Mail.read('some_saved_mail.file'))
  puts "mail has default carrier subject" if mail.subject.empty?

  # access the sender's phone number
  puts "mail was from phone #{mail.number}"

  # most mail are either image or video, default_media will return the largest
  # (non-advertising) video or image found
  file = mail.default_media
  puts "mail had a media: #{file.inspect}" unless file.nil?

  # finds the largest (non-advertising) text found
  file = mail.default_text
  puts "mail had some text: #{file.inspect}" unless file.nil?

  # mail.media is a hash that is indexed by mime-type.
  # The mime-type key returns an array of filepaths
  # to media that were extract from the mail and
  # are of that type
  mail.media['image/jpeg'].each {|f| puts "#{f}"}
  mail.media['text/plain'].each {|f| puts "#{f}"}

  # print the text (assumes mail had text)
  text = IO.readlines(mail.media['text/plain'].first).join
  puts text

  # save the image (assumes mail had a jpeg)
  FileUtils.cp mail.media['image/jpeg'].first, '/some/where/useful', :verbose => true

  puts "does the mail have quicktime video? #{!mail.media['video/quicktime'].nil?}"

  puts "plus run anything that Mail provides, e.g. #{mail.to.inspect}"

  # check if the mail is from a mobile phone
  puts "mail is from a mobile phone #{mail.is_mobile?}"

  # determine the device type of the phone
  puts "mail is from a mobile phone of type #{mail.device_type?}"

  # inspect default media's exif data if exifr gem is installed and default
  # media is a jpeg or tiff
  puts "mail's default media's exif data is:"
  puts mail.exif.inspect

  # Block support, process and receive all media types of video.
  mail.process do |media_type, files|
    # assumes a Clip model that is an AttachmentFu
    Clip.create(:uploaded_data => files.first, :title => "From phone") if media_type =~ /video/
  end

  # Another AttachmentFu example, Picture model is an AttachmentFu
  picture = Picture.new
  picture.title = mail.subject
  picture.uploaded_data = mail.default_media
  picture.save!

  #remove all the media that was put to temporary disk
  mail.purge

== REQUIREMENTS

* Mail (mail)
* Nokogiri (nokogiri)
* UUIDTools (uuidtools)
* EXIF Reader (exif)

== INSTALL

* sudo gem install mms2r

== SOURCE

git clone git://github.com/monde/mms2r.git

== AUTHORS

Copyright (c) 2007-2010 by Mike Mondragon (blog[http://plasti.cx/])

MMS2R's Flickr page[http://www.flickr.com/photos/8627919@N05/]

== CONTRIBUTORS

* Luke Francl (blog[http://railspikes.com/])
* Will Jessup (blog[http://www.willjessup.com/])
* Shane Vitarana (blog[http://www.shanesbrain.net/])
* Layton Wedgeworth (http://www.beenup2.com/)
* Jason Haruska (blog[http://software.haruska.com/])
* Dave Myron (company[http://contentfree.com/])
* Vijay Yellapragada
* Jesse Dp (github profile[http://github.com/jessedp])
* David Alm
* Jeremy Wilkins
* Matt Conway (github profile[http://github.com/wr0ngway])
* Kai Kai
* Michael DelGaudio
* Sai Emrys (blog[http://saizai.com])
* Brendan Lim (github profile[http://github.com/brendanlim])
* Scott Taylor (github profile[http://github.com/smtlaissezfaire])
* Jaap van der Meer (github profile[http://github.com/japetheape])
* Karl Baum (github profile[http://github.com/kbaum])

== LICENSE

(The MIT License)

Copyright (c) 2007, 2008 Mike Mondragon (mikemondragon@gmail.com).
All rights reserved.

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
