wp() {
    case $1 in 
        "dockerk8s")
        command code ~/Projects/DockerKub_tutorials
        ;;
        *)
        echo "List of workspaces \n"
        echo "(1) dockerk8s - Acadamind Docker and Kubernetes tutorials."
        ;;
    esac
}
