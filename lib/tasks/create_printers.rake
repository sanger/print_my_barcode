# frozen_string_literal: true

    namespace :printers do
        desc 'generate list of printers'
        task create: :environment do |_t|
            existing_printers = `lpstat -a`
            Printer.all.each do |printer| 
                if existing_printers.include? printer.name 
                else
                    sh "sudo lpadmin -p #{printer.name} -v socket://#{printer.name}.internal.sanger.ac.uk -E"
                    puts "Added printer ~> #{printer.name}"
                end
            end
        end
    end