require 'faraday'
require 'nokogiri'
require 'uri'
require 'net/http'
require 'json'
require 'colorize'
require 'socket'




def open_file_search()
	threads = []
	print("[<3] Input File : ")
	name_file = gets.chomp
	File.foreach(name_file).each do |keyword|
		threads << Thread.new(keyword) {|local|
			keyword_strip = keyword.rstrip()
			search_crt(keyword_strip)
		}

		#puts("[!] request TimeOUT ")
	end

	threads.each {|keyword| keyword.join}
end

def search_crt(keyword)
	url = "https://crt.sh/?q="+keyword
	begin
		request = Faraday.get(url)
		if request.status == 200
			grabber(request.body, keyword)
			return true
		else
			#puts('[!] Timeout')
			puts("[!] ERROR : #{keyword} HTTP CODE : #{request.status}")
		end
	rescue => error
		puts(error)
		puts('[!] TimeOUT')
	end
end

def grabber(source, keyword)
	puts("[!] Grabbing Keyword : #{keyword}....")
	html = source.gsub("<BR>", "\n")

	parsed_url = Nokogiri::HTML.parse(html)
	tesst = parsed_url.search('td').map{ |td| td.content }
	namez = tesst
	namez.each do |list_site|
		parsing_site(list_site)
		#File.open("td.txt", "a"){|f| f.write "#{sites}\n"}
	end
end

@safe_domain = []
def parsing_site(list_site)
	total_domain = []
	total_domain.push(list_site)



	duplicated_domain = []
	#anti_dupli = File.read("result_grab_thread.txt")
	total_domain.each do |mouze|
		begin
			get_linksz = mouze.match(/^[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,3}$/ix)
			if get_linksz
				
				File.open("result_grab_thread.txt", "a"){|f| f.write "#{get_linksz}\n"}
				
			else
			end



		rescue => error
			#puts(error)
			return false
		end
	end


end

def remove_duplicate_thrd()
	#read first line
	begin
		z = File.readlines('result_grab_thread.txt', chomp: true)
		first_length = z.length()
		puts("[!] Line before remove : #{first_length}")


		#remove duplicate
		a = File.readlines('result_grab_thread.txt', chomp: true).
		uniq { |line| line.sub(/\A\d+\./, '') }.
	  	join("\n")
	  	File.open("result_grab_thread.txt", "w"){|f| f.write "#{a}\n"}




	  	#Calculate length after remove duplicate
	  	b = File.readlines('result_grab_thread.txt', chomp: true)
	  	after_length = b.length()

	  	calculate_length(first_length, after_length)
	rescue 

	end


end

def calculate_length(before, after)
	zanzu = before.to_i
	zanzu2 = after.to_i

	lamne = zanzu - zanzu2
	puts("[?] Remove : #{lamne} lines")
	puts("[!] Total domain grabbed : #{zanzu2}")
	main_scanner_cms()

end

def readline2()
	file = File.read("fb.txt")
	puts(file)
end

def main_scanner_cms()
	threads = []
	File.foreach("result_grab_thread.txt").each do |sites|
		threads << Thread.new(sites){|local|
			if sites.include?"://"
				weblist = sites
			else
				weblist = "http://"+sites
			end
			sitee = weblist.gsub("\n", "")
			scanner_cms_thrd(sitee)

		}
	end
	threads.each {|sites| sites.join}
end

def scanner_cms_thrd(sites)

	opencart1 = sites+"/admin/view/javascript/common.js"
	osCommerce = sites+"/admin/includes/general.js"
	laravel1 = sites+"/.env"
	wordpress_1 = sites
  	
	tetapan = 90
	andeskor = 30
	b = ("#{sites} " + "-" * andeskor)
	perhitungan = b.length - tetapan
	perhitungan2 = perhitungan.to_s.gsub("-", "")
	hasil_andeskor = 30 + perhitungan2.to_i
	
	andeskor2 = ('[ '.colorize(:cyan)+ "#{sites}".colorize(:green)+ ' ]'.colorize(:cyan) + "-" * hasil_andeskor)

  	begin
	  	if(wordpress(wordpress_1))
			puts(andeskor2.to_s + "[ ".colorize(:cyan) + "200".colorize(:green) + " ]".colorize(:cyan) + " -- " + "[ ".colorize(:cyan) + "WORDPRESS".colorize(:yellow) + " ]".colorize(:cyan))
			File.open("wordpress.txt", "a"){|f| f.write "#{sites}\n"}		
		elsif(joomla(sites))
			puts(andeskor2.to_s + "[ ".colorize(:cyan) + "200".colorize(:green) + " ]".colorize(:cyan) + " -- " + "[ ".colorize(:cyan) + "JOOMLA".colorize(:yellow) + " ]".colorize(:cyan))
			File.open("joomla.txt", "a"){|f| f.write "#{sites}\n"}
		elsif(drupal(sites))
			puts(andeskor2.to_s + "[ ".colorize(:cyan) + "200".colorize(:green) + " ]".colorize(:cyan) + " -- " + "[ ".colorize(:cyan) + "DRUPAL".colorize(:yellow) + " ]".colorize(:cyan))
			File.open("drupal.txt", "a"){|f| f.write "#{sites}\n"}
		elsif(opencart(opencart1))
			puts(andeskor2.to_s + "[ ".colorize(:cyan) + "200".colorize(:green) + " ]".colorize(:cyan) + " -- " + "[ ".colorize(:cyan) + "OPENCART".colorize(:yellow) + " ]".colorize(:cyan))
			File.open("opencart.txt", "a"){|f| f.write "#{sites}\n"}
		elsif(oscommerce(osCommerce))
			puts(andeskor2.to_s + "[ ".colorize(:cyan) + "200".colorize(:green) + " ]".colorize(:cyan) + " -- " + "[ ".colorize(:cyan) + "OSCOMMERCE".colorize(:yellow) + " ]".colorize(:cyan))
			File.open("oscommerce.txt", "a"){|f| f.write "#{sites}\n"}
		elsif(laravel(laravel1))
			puts(andeskor2.to_s + "[ ".colorize(:cyan) + "200".colorize(:green) + " ]".colorize(:cyan) + " -- " + "[ ".colorize(:cyan) + "LARAVEL".colorize(:yellow) + " ]".colorize(:cyan))
			File.open("laravel.txt", "a"){|f| f.write "#{sites}\n"}
		else
			puts(andeskor2.to_s + "[ ".colorize(:cyan) + "404".colorize(:green) + " ]".colorize(:cyan) + " -- " + "[ ".colorize(:cyan) + "UNKNOWN".colorize(:yellow) + " ]".colorize(:cyan))
			File.open("unknown.txt", "a"){|f| f.write "#{sites}\n"}
		
		end
	  
  	rescue => error
		puts(andeskor2.to_s + "[ ".colorize(:cyan) + "404".colorize(:green) + " ]".colorize(:cyan) + " -- " + "[ ".colorize(:cyan) + "ERROR".colorize(:yellow) + " ]".colorize(:cyan))
  		#puts(error)
  	end
  	
end

def laravel(sites)
	conn = Faraday.new do |conn|
		conn.options.timeout = 3
	end

	request = conn.get(sites)
	if request.body.include?"APP_NAME"
		return true
	else
		return false
	end
end
def vbulletin(sites)
	vbulletin1 = sites+"/images/editor/separator.gif"
	vbulletin2 = sites+"/js/header-rollup-334.js"
	conn = Faraday.new do |conn|
		conn.options.timeout = 3
  	end

  	request_1 = conn.get(vbulletin1)
  	if request_1.body.include?"GIF89a"
  		return true

  	request_2 = conn.get(vbulletin2)
  	elsif request_2.body.include?"js.compressed/modernizr.min.js"
  		return true
  	else
  		return false
  	end
end
def oscommerce(sites)
	conn = Faraday.new do |conn|
		conn.options.timeout = 3
  	end

  	request = conn.get(sites)
  	if request.body.include?"function SetFocus()"
  		return true
  	else
  		return false
  	end
end
def opencart(sites)
	conn = Faraday.new do |conn|
		conn.options.timeout = 3
  	end

  	request = conn.get(sites)
  	if request.body.include?"getURLVar(key)"
  		return true
  	else
  		return false
  	end
end
def drupal(sites)
	drupal1 = sites+"/misc/ajax.js"
	drupal2 = sites
	conn = Faraday.new do |conn|
		conn.options.timeout = 3
  	end

  	request_1 = conn.get(drupal1)
  	if request_1.body.include?"Drupal.ajax"
  		return true
  	end
  	request_2 = conn.get(drupal2)
  	if request_2.body.include?"/sites/default/files"
  		return true
  	
  	else
  		return false
  	end
end
def joomla(sites)
	joomla1 = sites+"/administrator/help/en-GB/toc.json"
	joomla2 = sites+"/administrator/language/en-GB/install.xml"
	joomla3 = sites+"/plugins/system/debug/debug.xml"
	joomla4 = sites+"/administrator/"

	conn = Faraday.new do |conn|
		conn.options.timeout = 3
  	end
  	request_1 = conn.get(joomla1)
  	if request_1.body.include?"COMPONENTS_BANNERS_BANNERS"
  		return true
  	end


  	request_2 = conn.get(joomla2)	
  	if request_2.body.include?"<author>Joomla!"
  		return true
  	end


  	request_3 = conn.get(joomla3)
  	if request_3.body.include?"<author>Joomla!"
  		return true
  	end
  	request_4 = conn.get(joomla4)
  	if request_4.body.include?"content=\"Joomla!"
  		return true

  	else
  		return false
  	end
end
def wordpress(sites)
	conn = Faraday.new do |conn|
		conn.options.timeout = 3
  	end
  	request = conn.get(sites)
  	if request.body.include?"/wp-include/"
  		return true
  	else
  		return false
  	end
end



def main()
	open_file_search()
end
