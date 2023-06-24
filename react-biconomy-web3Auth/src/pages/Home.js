export default function Home(props){

    console.log(props)


    const containerStyles = {
        backgroundColor: '#454545',
        borderRadius: '10px',
        width: '80%',
        padding: '80px',
        marginTop: '80px',
        marginLeft: '60px',
    }

    return (
        <div style={containerStyles}>
        <h1>Discover Events</h1>  
        </div>
    )
}