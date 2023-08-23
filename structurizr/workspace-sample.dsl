workspace "Spring Context" "Spring's surrounding architecture & dependencies" {
	model {
		properties {
            "structurizr.groupSeparator" "/"
        }

		user = person "User"
        uqService = softwareSystem "UQ SSO" "Provides OAuth 2.0 Authentication functionality for UQ Students"
        btb = softwareSystem "BTB" {
            database = container "Database" "Stores Block Information" "MySQL"
            frontend = container "Interactive Web Pages" "Provides the Online Interface" "React"

            user -> frontend

            webAPI = container "WebAPI" "Delivers BTB Functionality" {
                group "User Domain" {
                    userController = component "User Controller" "Routes User functionalites to the corresponding Services" "Golang"
                    userService = component "User Service" "Contains all the Business Logic for User Domain" "Golang"
                    userRepository = component "User Repository" "Contains all the Persistence Logic for User Domain" "Golang"

                    frontend -> userController
                    userController -> userService
                    userService -> userRepository
                    userRepository -> database
                }

                group "Block Domain" {
                    blockController = component "Block Controller" "Routes Block functionalites to the corresponding Services" "Golang"
                    blockService = component "Block Service" "Contains all the Business Logic for Block Domain" "Golang"
                    blockRepository = component "Block Repository" "Contains all the Persistence Logic for Block Domain" "Golang"
                    
                    frontend -> blockController
                    blockController -> blockService
                    blockService -> blockRepository
                    blockRepository -> database
                }
            }

            webAPI2 = container "WebAPI User Detail" "Delivers BTB Functionality" {
                userControllerDetail = component "User Controller" "Routes User functionalites to the corresponding Services" "Golang"
                frontend -> userControllerDetail
                userRepositoryDetail = component "User Repository" "Contains all the Persistence Logic for User Domain" "Golang" {
                    -> database
                }
                userRepositoryUQ = component "UQ User Repository" "Handles all the communication to UQ SSO" {
                    -> uqService
                }
                
                group "User Service" {
                    userServiceInterface = component "User Service Facade" "Defines all the contract of User Service" "Interface"
                    userServiceImpl = component "Mock User Service" "Mocked User Service for MVP"
                    
                    userControllerDetail -> userServiceInterface
                    userServiceInterface -> userServiceImpl
                    userServiceImpl -> userRepositoryDetail

                    userServiceUQ = component "UQ User Proxy Service" "Proxies between BTB and UQ SSO and handles Data Linkage"
                    userServiceInterface -> userServiceUQ
                    userServiceUQ -> userRepositoryUQ
                }
            }

            webAPI3 = container "WebAPI Block Detail" "Delivers BTB Functionality" {
                blockControllerDetail = component "Block Controller" "Routes Block functionalites to the corresponding Services" "Golang"
                frontend -> blockControllerDetail
                courseRepositoryDetail = component "Course Repository" "Contains all the Persistence Logic for Courses" "Golang" {
                    -> database
                }
                courseRepositoryUQ = component "UQ Course Repository" "Handles all the communication to UQ Timetable" {
                    -> uqService
                }
                
                group "Course Service" {
                    courseServiceInterface = component "Course Service Facade" "Defines all the contract of Course Service" "Interface"
                    courseServiceImpl = component "Mock Course Service" "Mocked Course Service for MVP"
                    
                    blockControllerDetail -> courseServiceInterface
                    courseServiceInterface -> courseServiceImpl
                    courseServiceImpl -> courseRepositoryDetail

                    courseServiceUQ = component "UQ Course Proxy Service" "Proxies between BTB and UQ SSO and handles Data Linkage"
                    courseServiceInterface -> courseServiceUQ
                    courseServiceUQ -> courseRepositoryUQ
                    courseServiceUQ -> courseRepositoryDetail
                }

                blockRepositoryDetail = component "Block Repository" "Contains all the Persistence Logic for Blocks" "Golang" {
                    -> database
                }
                
                blockServiceDetail = component "Block Service" "Contains all the Business Logic for Block Domain" "Golang" {
                    -> blockRepositoryDetail
                }
                summaryServiceDetail = component "Summary Service" "Contains all the Business Logic for Summarizing Block" "Golang" {
                    -> blockRepositoryDetail
                }
                blockControllerDetail -> blockServiceDetail
                blockControllerDetail -> summaryServiceDetail
            }
        }
	}

	views {
        component webAPI "component_diagram" {
			include *
            autoLayout lr
		}
        component webAPI2 "user_implementation_detail" {
			include *
            autoLayout lr
		}

        component webAPI3 "block_implementation_detail" {
			include *
            autoLayout lr
		}
        
		styles {
			element desc {
				width 400
				height 100
			}
			element ancillary {
				background #f2c679
				/* colour is text colour. */
				colour #000000
			}
			element mobile {
				shape MobileDevicePortrait
				background #b3deff
				/* colour is text colour. */
				colour #000000
			}
			element db {
				shape Cylinder
				background #bfffda
				/* colour is text colour. */
				colour #000000
			}
			element browser {
				shape WebBrowser
				background #b3deff
				/* colour is text colour. */
				colour #000000
			}
			element failover {
				opacity 45
			}
		}

        themes default https://static.structurizr.com/themes/oracle-cloud-infrastructure-2021.04.30/theme.json
	}
}