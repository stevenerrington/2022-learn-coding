"""
PYTHON TUTORIAL SCRIPT
2022-01-15: I've just put together this script to try different concepts with Python.
I'm taking most of the ideas from the w3schools website (https://www.w3schools.com/python/python_comments.asp)
"""

# Array indexing ########################################################
cars = ["Ford", "Volvo", "BMW"] # Make a list of car names
x = cars[0]                     # Make a variable by selecting part of the array
cars[0] = "Toyota"              # Change a value within an array

x = len(cars)                   # Get the length of the array
print(x)                        # Print value to terminal

cars.append("Honda")            # Add element to an array
cars.pop(1)                     # Remove element from an array
cars.remove(1)                  # Remove element from an array (alt.)



# FOR loops     #########################################################
for x in cars:
  print(x)


# IF statements #########################################################
i = 10 # Arbitary integer

if i <= 5: # If i is greater than or equal to 5, then print the statement
    print("Value is less than or equal to 5")
else:      # Otherwise print the alternative
    print("Value is greater than 5")

# Note: in contrast to Matlab, no "end" statement is needed.

