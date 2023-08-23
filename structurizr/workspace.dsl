workspace "Spring Context" "Spring's surrounding architecture & dependencies" {
	model {
		properties {
            "structurizr.groupSeparator" "/"
        }

		proofExpert = person "Proof Expert"
        developer = person "GraalVM Developer"
        jEdit = softwareSystem "Isabelle/jEdit" "IDE for Isabelle" {
            tags "Overview"
        }
        isabelle = softwareSystem "Isabelle" "Interactive Theorem Prover" {
            tags "Isabelle Client - Server"
            isabelleScala = container "Isabelle/Scala" "Frontend for Isabelle" "Scala" {
                tags "Isabelle Client - Server"
                isabelleClient = component "Isabelle Client" "Proxy for Isabelle Server" "Scala" {
                    tags "Overview"
                }
                isabelleServer = component "Isabelle Server" "Wrapper for Isabelle ML" "Scala" {
                    tags "Isabelle Client - Server"
                    isabelleClient -> isabelleServer
                }
            }
            isabelleML = container "Isabelle/ML" "Core Functionalities of Isabelle" "ML" {
                tags "Isabelle Client - Server"
            }

            isabelleServer -> isabelleML
            isabelleScala -> isabelleML
        }

        jEdit -> isabelleScala
        proofExpert -> jEdit

        smt = softwareSystem "SMT Solvers"
        isabelleML -> smt
        # externalIsabelleML -> smt

        framework = softwareSystem "Automated Testing Framework" {
            frontend = container "Framework Facade" "CLI / GUI" "Java"

            developer -> frontend

            group "Core Framework" {
                clientFacade = container "Isabelle Client's Facade" "Service to Hit Isabelle Server" "Java" {
                    tags "Isabelle Client - Server"

                    -> isabelleClient {
                        tags "Overview"
                    }
                }
                scalaFacade = container "Isabelle/Scala's Facade" "Service to manage Isabelle/Scala" "Java" {
                    tags "Isabelle/Scala"
                }

                group "Internal Isabelle" {
                    internalIsabelleML = container "Internal Isabelle/ML" "ML" {
                        tags "Isabelle/Scala"
                        tags "InternalIsabelle"
                        -> smt {
                            tags "Isabelle/Scala"
                            tags "InternalIsabelle"
                        }
                    }

                    internalIsabelleScala = container "Internal Isabelle/Scala" "Scala" {
                        tags "Isabelle/Scala"
                        tags "InternalIsabelle"
                        -> internalIsabelleML
                        scalaFacade -> internalIsabelleScala
                    }

                    internalIsabelleClient = container "Internal Isabelle Client" "Proxy for Isabelle Server" "Scala" {
                        tags "Isabelle Client - Server"
                        tags "InternalIsabelle"
                        -> isabelleServer
                        clientFacade -> internalIsabelleClient
                    }
                }

                frontend -> clientFacade
                frontend -> scalaFacade
            }
        }

        developer -> framework
	}

	views {
        systemLandscape "framework_overview" "A High Level Overview of the Solution" {
            include *
        }

        filtered "framework_overview" exclude "InternalIsabelle" "framework_overview_1"

        container isabelle "isabelle_overview" "A High Level Overview of Isabelle" {
            include *
        }

        filtered "isabelle_overview" exclude "InternalIsabelle" "isabelle_overview_1"

        container framework "isabelle_client_server" "Utilizing Isabelle Client - Server" {
            include *
        }

        filtered "isabelle_client_server" exclude "Isabelle/Scala,Overview" "isabelle_client_server_1"

        container framework "isabelle_scala" "Extending Isabelle/Scala" {
            include *
        }

        filtered "isabelle_scala" exclude "Isabelle Client - Server,Overview" "isabelle_scala_1"

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