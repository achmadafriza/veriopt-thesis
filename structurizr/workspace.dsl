workspace "Spring Context" "Spring's surrounding architecture & dependencies" {
	model {
		properties {
            "structurizr.groupSeparator" "/"
        }

		proofExpert = person "Proof Expert"
        developer = person "GraalVM Developer"
        
        jEdit = softwareSystem "Isabelle/jEdit" "IDE for Isabelle" {
            tags "Overview"

            proofExpert -> jEdit "Uses Tool"
        }

        smt = softwareSystem "SMT Solvers"

        externalIsabelle = softwareSystem "Isabelle" "Interactive Theorem Prover" {
            tags "Overview"
            externalIsabelleScala = container "Isabelle/Scala" "Frontend for Isabelle" "Scala" {
                tags "Overview"
                
                externalIsabelleClient = component "Isabelle Client" "Proxy for Isabelle Server" "Scala" {
                    tags "Overview"
                }

                externalIsabelleServer = component "Isabelle Server" "Wrapper for Isabelle ML" "Scala" {
                    tags "Overview"

                    externalIsabelleClient -> externalIsabelleServer "Send Theories"
                }

                jEdit -> externalIsabelleScala "Uses"
            }
            externalIsabelleML = container "Isabelle/ML" "Core Functionalities of Isabelle" "ML" {
                tags "Overview"

                externalIsabelleServer -> externalIsabelleML "Process Theories"
                -> smt "Proof Predicates"
            }
        }

        framework = softwareSystem "VeriTest" "Automated Testing Framework" "Java" {
            isabelle = container "Isabelle Server" "" "Internal" {
                -> smt "Automated Proofing" {
                    tags "InternalIsabelle"
                }
            }

            service = container "Service" "" "Java" {
                isabelleClient = component "Isabelle Client" "" "Subprocess" {
                    -> isabelle "Process Theory"
                }

                -> externalIsabelleClient "Uses" {
                    tags "Overview"
                }

                controller = component "Controller" "Handle User Requests" "Spring Boot REST Controller" {
                    developer -> controller "Sends Optimization Rules to Proof"
                }

                isabelleService = component "Isabelle Service" "Facade for Isabelle" "Spring Bean" {
                    controller -> isabelleService "Passes Rules"
                }

                isabelleClientInterface = component "Isabelle Client Interface" "" "Interface"

                isabelleBridge = component "Abstract Isabelle Client" "Bridge Abstraction for Isabelle" "Abstract Class" {
                    isabelleService -> isabelleBridge "Process Rule"
                    -> isabelleClientInterface "Implements"
                }

                isabelleProcess = component "Isabelle Process" "Proxy for Isabelle Client Subprocess" "Spring Bean" {
                    -> isabelleBridge "Extends"
                    -> isabelleClient "Sends Commands and Theory"
                }
            }
        }
	}

	views {
        systemLandscape "framework_overview" "A High Level Overview of the Solution" {
            include *
        }

        filtered "framework_overview" exclude "InternalIsabelle" "framework_overview_1"

        container externalIsabelle "isabelle_overview" "A High Level Overview of Isabelle" {
            include *
        }

        filtered "isabelle_overview" exclude "InternalIsabelle" "isabelle_overview_1"

        container framework "isabelle_client_server" "Utilizing Isabelle Client - Server" {
            include *
        }

        filtered "isabelle_client_server" exclude "Overview" "isabelle_client_server_1"

        component service "veritest_solution" "Overview of Veritest" {
            include *
            include smt
        }

        filtered "veritest_solution" exclude "Overview" "veritest_solution_1"

        # dynamic framework "graalvm_dev_workflow" {
		# 	developer ->  frontend "Send an Optimization Rule"
        #     frontend -> clientFacade "Pass Request"
        #     clientFacade -> internalIsabelleClient "Handle Isabelle Communications"
        #     internalIsabelleClient -> isabelle "Pass to Isabelle Server"
        #     isabelle -> smt "Process Optimization Rule"
        #     smt -> isabelle "Send Response"
        #     isabelle -> internalIsabelleClient "Send Response"
        #     internalIsabelleClient -> clientFacade "Send Response"
        #     clientFacade -> frontend "Send Response"

        #     frontend -> developer "Result: Found Counterexample"
        #     frontend -> developer "Result: Found Proof"
        #     frontend -> developer "Result: Can't decide!"
		# }

		styles {
            element "Element" {
                fontSize "36"
            }
            element "Boundary" {
                fontSize "36"
            }
            element "Group" {
                fontSize "36"
            }
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