import tensorflow as tf
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense, Flatten
from tensorflow.keras.utils import to_categorical
from tensorflow.keras.optimizers import Adam
import matplotlib.pyplot as plt
import numpy as np

(x_train, y_train), (x_test, y_test) = tf.keras.datasets.mnist.load_data()

x_train = x_train / 255.0
x_test = x_test / 255.0

y_train = to_categorical(y_train, 10)
y_test = to_categorical(y_test, 10)

print("Training Shape :", x_train.shape)
print("Testing Shape  :", x_test.shape)

model = Sequential([
    Flatten(input_shape=(28, 28)),
    Dense(128, activation='relu'),
    Dense(64, activation='relu'),
    Dense(10, activation='softmax')
])

model.summary()

model.compile(
    optimizer='adam',
    loss='categorical_crossentropy',
    metrics=['accuracy']
)

history = model.fit(
    x_train,
    y_train,
    epochs=10,
    batch_size=32,
    validation_split=0.2
)

test_loss, test_accuracy = model.evaluate(x_test, y_test)

print("\nTest Loss :", test_loss)
print("Test Accuracy :", test_accuracy)

learning_rates = [0.01, 0.001, 0.0001]
batch_sizes = [32, 64, 128]

print("\nHyperparameter Results\n")

for lr in learning_rates:
    for bs in batch_sizes:

        temp_model = Sequential([
            Flatten(input_shape=(28,28)),
            Dense(128, activation='relu'),
            Dense(64, activation='relu'),
            Dense(10, activation='softmax')
        ])

        optimizer = Adam(learning_rate=lr)

        temp_model.compile(
            optimizer=optimizer,
            loss='categorical_crossentropy',
            metrics=['accuracy']
        )

        temp_model.fit(
            x_train,
            y_train,
            epochs=3,
            batch_size=bs,
            verbose=0
        )

        loss, acc = temp_model.evaluate(x_test, y_test, verbose=0)

        print(f"Learning Rate={lr}, Batch Size={bs}")
        print(f"Accuracy={acc:.4f}, Loss={loss:.4f}\n")

plt.plot(history.history['accuracy'], label='Training Accuracy')
plt.plot(history.history['val_accuracy'], label='Validation Accuracy')

plt.title('Accuracy over Epochs')
plt.xlabel('Epochs')
plt.ylabel('Accuracy')
plt.legend()
plt.show()

plt.plot(history.history['loss'], label='Training Loss')
plt.plot(history.history['val_loss'], label='Validation Loss')

plt.title('Loss over Epochs')
plt.xlabel('Epochs')
plt.ylabel('Loss')
plt.legend()
plt.show()

predictions = model.predict(x_test)

for i in range(5):

    plt.imshow(x_test[i], cmap='gray')

    plt.title(
        f"Predicted: {np.argmax(predictions[i])} | True: {np.argmax(y_test[i])}"
    )

    plt.axis('off')
    plt.show()