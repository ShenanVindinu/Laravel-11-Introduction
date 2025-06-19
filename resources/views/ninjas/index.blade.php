<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ninja Network | Home</title>
</head>
<body>
    <h2>Currently available Ninjas</h2>
    <p>{{ $greeting }}</p>
    
    <ul>
        <li>
            <a href="">
                {{$ninjas[0]["name"] }}
            </a>
        </li>
        <li>
            <a href="">
                {{$ninjas[1]["name"] }}
            </a>
        </li>
    </ul>
</body>
</html>