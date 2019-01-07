require 'pry'

def clear_screen
  puts `clear`
end

def print_title
  title = <<EOF
  ================================================================================
  ==================  ============================================================
  ==================  ============================================================
  ==  ==============  =============  =========================  ==================
  =    ==  ===   ===  =  ===   ===    ==  =  = ===  ===   ===    ===   ===  =   ==
  ==  =======  =  ==    ===  =  ===  ===        ======  =  ===  ===  =  ==    =  =
  ==  ===  ==  =====   ====     ===  ===  =  =  ==  ===  =====  ===     ==  ======
  ==  ===  ==  =====    ===  ======  ===  =  =  ==  ====  ====  ===  =====  ======
  ==  ===  ==  =  ==  =  ==  =  ===  ===  =  =  ==  ==  =  ===  ===  =  ==  ======
  ==   ==  ===   ===  =  ===   ====   ==  =  =  ==  ===   ====   ===   ===  ======
  ================================================================================
EOF

@pastel = Pastel.new
puts @pastel.cyan(title)
end

def welcome
  clear_screen
  print_title
  puts "Welcome to TicketMister"
  sleep(3)
  main_menu
 end

 def main_menu
  @prompt = TTY::Prompt.new
  choice = @prompt.select("Sign Up or Login to Continue", ["Sign Up", "Login", "Exit"])
  if choice == "Login"
    login
  elsif choice == "Exit"
    exit
  else
    sign_up
  end
end

def sign_up
  clear_screen
  print_title
  @name = @prompt.ask('Please Enter Name')
  @email = @prompt.ask('Please Enter Email')
  password = @prompt.mask('Please Enter Password')
  password_2 = @prompt.mask('Please Re-Enter Password')
if !User.all.find_by(name: @name).nil? && User.all.find_by(name: @name).name == @name
      choice = @prompt.select("Account already exists. What would you like to do?", ["Login", "Delete Account", "Try Again", "Exit"])
      case choice
    when "Login"
      login
    when "Delete Account"
      delete_user
    when "Try Again"
      sign_up
   end
end
  @user = User.create(name: @name, email: @email)
  sleep(2)
  clear_screen
  print_title
  main_menu
end

def delete_user
  User.all.find_by(name: @name).destroy
  puts "#{@name} has been deleted."
  sleep(3)
  main_menu
end

def refresh_user
  @user = User.find_by(name: @name ) unless @name == nil
end

def login
  clear_screen
  print_title
  @name = @prompt.ask("Please Enter Name")
  password = @prompt.mask("Password")
  refresh_user
  if @user.nil?
    clear_screen
    print_title
    puts "Name does not match account. Please create a new account."
    sleep(3)
    clear_screen
    print_title
    main_menu
  else
    sleep(2)
    user_menu
  end
end

def user_menu
  clear_screen
  print_title
  sleep(2)
  choice = @prompt.select('What would you like to do?', ["Buy Tickets", "Tickets Purchased", "Logout"])
  case choice
  when "Buy Tickets"
    view_tickets
  when "Tickets Purchased"
    user_tickets
  when "Logout"
    main_menu
  end
end

def view_tickets
  event = Event.all
  puts tp event
  buy_tickets
end

def buy_tickets
  puts "Enter purchse code (event_id) for the event:"
  id = gets.chomp.to_i
  Ticket.create(user: @user,event_id: id, section: "GEN")
  sleep(1)
  puts "Purchase Completed. Please Check You Email For Ticket."
  sleep(3)
  user_menu
  end




def user_tickets
  clear_screen
  print_title
  puts tp @user.tickets
  user_menu_2
end

def user_menu_2
  choice = @prompt.select("Request Refund or Return to Menu", ["Upgrade Ticket", "Refund Request", "Return To Menu"])
  case choice
  when "Upgrade Ticket"
    upgrade_to_vip
  when "Refund Request"
    refund
  when "Return To Menu"
    user_menu
  end
end

def upgrade_to_vip
  choice = @prompt.select("Would you like to upgrade your ticket to VIP", ["Yes", "No"])
  if choice =="Yes"
    puts "Enter Ticket Code to Upgrade:"
    id = gets.chomp.to_i
    user = Ticket.find_by(id: id)
    user.update(section: "VIP")
    sleep(1)
    puts "Ticket Upgraded. You Are Now Very Important"
    sleep(2)
    user_menu
  else
    user_menu_2
  end
end


def refund
  puts "Enter Ticket Code for Refund:"
  input = gets.chomp.to_i
  Ticket.all.find_by(id: input).destroy
  refund_message
end

def refund_message
  puts "Processing. Refunds will reflect in in 7-10 business days"
  sleep(3)
  user_menu
end
