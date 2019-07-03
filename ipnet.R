
ipnet <- function(address=NULL) {
        list_of_packages <- c("stringr", "dplyr")
        for (p in list_of_packages) {if(p %in% rownames(installed.packages()) == FALSE) {
                install.packages(p, repos = "http://cran.us.r-project.org")
                library(p, character.only = TRUE)} else library(p, character.only = TRUE)
        }
        
        #Vector for calculating the wildcard (s-subnet mask)
        s=c(255,255,255,255)
        
        #Read the r_ipnet subnettting file from Google Drive
        id <- "1Bzbb9OV8oKax-OF7HamndGX7faV-b717" # google file ID
        subnet_table <- read.csv(sprintf("https://docs.google.com/uc?id=%s&export=download", id))
        
        #User Input
        if (is.null(address)==TRUE){
                address <- as.character(readline(prompt="Enter IP address and Subnet Mask (with a space in between) or CIDR: "))
        }
        #Regular Expression when the user submits CIDR (address1 and first if statement) or IP and Subnet Mask (address2 and else if statement). If the function gets an IP address without specifying CIDR or subnet mask is treated as "32" and assigned to address1 variable.
        if (!is.na(str_extract(address, "[[:digit:]]{1,3}\\.[[:digit:]]{1,3}\\.[[:digit:]]{1,3}\\.[[:digit:]]{1,3}\\/[[:digit:]]{1,2}$"))) {
                address1 <- str_extract(address, "[[:digit:]]{1,3}\\.[[:digit:]]{1,3}\\.[[:digit:]]{1,3}\\.[[:digit:]]{1,3}\\/[[:digit:]]{1,2}$")   
                print("Address and Subnet Mask from CIDR were EXTRACTED successfully (1)")
        } else if (!is.na(str_extract(address, "[[:digit:]]{1,3}\\.[[:digit:]]{1,3}\\.[[:digit:]]{1,3}\\.[[:digit:]]{1,3}[\\s][[:digit:]]{1,3}\\.[[:digit:]]{1,3}\\.[[:digit:]]{1,3}\\.[[:digit:]]{1,3}"))) {
                address2 <-  str_extract(address, "[[:digit:]]{1,3}\\.[[:digit:]]{1,3}\\.[[:digit:]]{1,3}\\.[[:digit:]]{1,3}[\\s][[:digit:]]{1,3}\\.[[:digit:]]{1,3}\\.[[:digit:]]{1,3}\\.[[:digit:]]{1,3}")
                print("Address and Subnet Mask were EXTRACTED successfully (2)")
        } else if (!is.na(str_extract(address, "[[:digit:]]{1,3}\\.[[:digit:]]{1,3}\\.[[:digit:]]{1,3}\\.[[:digit:]]{1,3}$"))){
                address1 <- str_extract(address, "[[:digit:]]{1,3}\\.[[:digit:]]{1,3}\\.[[:digit:]]{1,3}\\.[[:digit:]]{1,3}$")
                address1 <- paste0(address1,"/32")
        }
        #To calculate the usable hosts we could also substract the prefix size from 32 and then result is the power that we need to raise 2 (e.g.,  for /24 -> 32-24= 8, and then we raise 2 to the power of 8 = 256 hosts) 
        if (exists("address1") == TRUE) {
                address <- strsplit(address1, "/", fixed = TRUE)
                subnet_info_from_table_extracted <- filter(subnet_table, subnet_table$prefix==address[[1]][2])
                #total_addresses <- (32-as.integer(address[[1]][2]))^2
                #usable_hosts <- (32-as.integer(address[[1]][2]))^2-2
        } else if (exists("address2") == TRUE) {
                address <- strsplit(address2, " ", fixed = TRUE)
                subnet_info_from_table_extracted <- filter(subnet_table, subnet_table$netmask==address[[1]][2])
        }
        
        subnet_mask <- as.character(subnet_info_from_table_extracted[,4])
        subnet_mask_for_binary_function <- subnet_mask
        subnet_mask <- strsplit(subnet_mask,".", fixed = TRUE)
        subnet_mask <- as.integer(unlist(subnet_mask))
        wildcard <- s-subnet_mask #calculate wildcard
        
        #variables that you can call
        wildcard <<- paste(wildcard, collapse = ".")
        ip <<-  address[[1]][1]
        netmask <<- subnet_info_from_table_extracted[,4]
        usable_hosts <<- subnet_info_from_table_extracted[,3]
        total_addresses <<- subnet_info_from_table_extracted[,2]
        prefix <<- subnet_info_from_table_extracted[,1]
        
        binary_ip <<- dec_to_binary(ip)
        binary_subnet <<- dec_to_binary(subnet_mask_for_binary_function)
}

#Transforms decimal to binary format (representation)
dec_to_binary <- function(v) { 
        ip <-  strsplit(v,".", fixed = TRUE)
        ip <- as.integer(unlist(ip))
        octet <- list(8,16,24,32)
        i <- 0
        a <- 1
        string <- numeric(32)
        for (decimal in rev(ip)) {
                while(decimal > 0) {
                        string[32 - i] <- decimal %% 2  #starts going from right to left 
                        decimal <- decimal %/% 2
                        i <- i + 1 
                }
                if (i<octet[a]) {
                        i <- as.integer(octet[a])
                        a <- a+1
                }
        }
        return(string)
}

#Prints IPv4 related information based on the given CIDR or Subnet mask
print.ipnet <- function() {
        print(paste0("Address: ", ip))
        print(paste0("Netmask: ", netmask))
        print(paste0("Number of usable hosts: ", usable_hosts))
        print(paste0("Number of addresses: ", total_addresses))
        print(paste0("Prefix length: ", prefix))
        print(paste0("Wildcard: ", wildcard))
        c_binary_ip <- paste(binary_ip, collapse = "")
        print(paste0("IP in binary: ", c_binary_ip))
        c_binary_subnet <- paste(binary_subnet,collapse = "")
        print(paste0("Subnet Mask in binary: ", c_binary_subnet))
}
