import ctypes

# Load the DLL file
my_dll = ctypes.CDLL('main.dll')

# Assuming the DLL has a function called `my_function`
result = my_dll.my_function()

# If the function expects arguments, pass them
# result = my_dll.my_function(arg1, arg2)

# Print the result
print(result)
