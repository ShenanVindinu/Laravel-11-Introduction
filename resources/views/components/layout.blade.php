<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ninja Network</title>
    <link href="https://fonts.googleapis.com/css2?family=Rubik&display=swap" rel="stylesheet">
    @vite('resources/css/app.css')    
</head>
<body>
    @if (session('success'))
        <div id="flash" class="p-4 text-center bg-green-50 text-green-500 font-bold" >
            {{ session('success') }}
        </div>
    @endif
    
    <header>
        <nav>
            <h1>
                <a href="{{ route('ninjas.index') }}">
                    Ninja Network
                </a>
            </h1>
            <a href="{{ route('ninjas.index') }}">All Ninjas</a>
            <a href="{{ route('ninjas.create') }}">Create New Ninjas</a>
        </nav>
    </header>

    <main class="container">
        {{ $slot }}
    </main>

</body>
</html>