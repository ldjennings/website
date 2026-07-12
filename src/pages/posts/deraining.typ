#import "../../lib/skeleton.typ": webpage
#import "../../lib/post.typ": post, fig, btn, post-nav

// Ported from the project's original GitHub Pages write-up (the Pages site
// is gone; content recovered from the repo README). Date is approximate:
// CS 539 ran summer 2023, but no authoritative completion date survives.
#let meta = (
  category: "machine learning",
  date: datetime(year: 2023, month: 8, day: 1),
  tags: ("python", "deep learning"),
  title: [Pixel Precipitation: Single Image Deraining with CVAE],
)

#webpage("posts/deraining.html", title: meta.title)[
  #post(..meta)[
    _A machine learning project by Liam Jennings, Tabatha Viso, &
    Nikesh Walling — Worcester Polytechnic Institute, CS 539,
    Prof. Kyumin Lee._

    = Project Motivation

    Gently watching raindrops roll down the window provides a calming and
    serene experience, but when driving, rain can impede clarity, even
    with reliable windshield wipers. In an increasingly automated world
    of autonomous vehicles, inclement weather, including raindrops, poses
    a significant challenge for computer vision and perception.
    Single-image deraining, a computer vision solution, comes into play
    to eliminate raindrops and streaks from images, restoring visual
    clarity. These models act as a filter on rainy images, enabling
    autonomous vehicles and other applications to function seamlessly in
    adverse weather conditions as if they were clear skies.

    = Existing Image Filtering Approaches

    Image filtering, a method that modifies pixel values, is commonly
    used in deraining, deblurring, and other similar image restoration
    applications. Some image filtering approaches include:

    - Adaptive filtering adjusts behavior based on rain characteristics,
      such as strength and direction, for better rain removal
    - Spatial filtering, such as Gaussian filters or bilateral filters,
      blurs images selectively to reduce rain impact while preserving
      scene details
    - Temporal filtering, used in video deraining, considers multiple
      consecutive frames to estimate rain streaks more effectively
    - Patch-based filtering processes images in independent patches for
      localized rain removal
    - Guided filtering uses a reference rain-free image to remove rain
      while preserving important details

    Machine learning and related techniques are used in conjunction with
    image filtering in order to restore images. These methods typically
    include deep learning (such as convolutional neural networks), math
    models (for describing rain properties and estimating rain streaks),
    support vector machines, and random forests.

    = Challenges

    The task of single image deraining comes with some challenges: One is
    dealing with the variety of rain features found in real-world
    situations. Raindrops can be of different shapes, sizes, densities,
    and orientations, making it hard to create a deraining model that
    works well for all types of rain patterns. Another problem is the
    lack of high-quality datasets containing pairs of clean and rainy
    images. Having enough data to train and test deraining models
    effectively is crucial, but gathering such datasets can be
    time-consuming and difficult. Many models are trained using
    computer-generated rain images. However, synthetic rain images may
    not capture all the complexities and nuances of real rain, which can
    affect how well the deraining models perform in actual rainy scenes.

    Additionally, evaluating deraining algorithms can be challenging. The
    usual subjective evaluation methods, like visual inspection or human
    judgment, can be influenced by personal biases, as well as
    time-consuming. It would be helpful to have more objective and
    quantitative evaluation metrics that better align with human
    perception. By addressing these issues, deraining models can become
    more reliable tools for enhancing visibility and safety in
    challenging weather conditions, especially for applications like
    autonomous vehicles.

    Our project aims to tackle low image visibility caused by raindrop
    blurs on glass, such as a car windshield or camera lens.

    = Convolutional Variational Autoencoder (CVAE) Architecture

    The proposed solution that we implemented is a Convolutional
    Variational Autoencoder. The architecture is as follows:

    - Preprocessing: Before feeding the data into the CVAE, a
      preprocessing step is applied to prepare the input images for
      further processing.

    - Encoder: The CVAE's encoder is responsible for mapping the input
      images into a latent space representation. It is comprised of:
      - Two convolutional layers to extract spatial information. The
        ReLU activation function is used in all layers to introduce
        non-linearity. Stride (2,2) is used in all layers to reduce the
        spatial dimensions of the feature maps (zero-padding is used).
      - One flatten layer reshapes the spatial information into a 1D
        vector
      - Two dense layers with ReLU activation functions are used to
        reduce the dimensionality of the feature maps while retaining
        hierarchal features
      - One sampling layer performs reparameterization

    - Reparameterization Trick: Reparameterization is used to ensure
      stochasticity while enabling backpropagation during training.
      Random noise sampled from a standard Gaussian distribution is
      applied to the mean and log-variance vectors obtained from the
      encoder. This generates a sample from the latent variable
      distribution, allowing the model to learn and explore the latent
      space effectively.

    - Decoder: The CVAE's decoder takes the sampled latent variable as
      input and aims to reconstruct the original image from this
      representation.
      - One dense layer inputs the sampled latent vector and projects it
        to a higher dimensional space
      - One reshape layer reshapes the 1D vector back into a 3D vector
        of size (30,45,256)
      - Three transposed convolutional layers with (2,2) strides and
        ReLU activation functions upscale feature maps back to the
        original image size
      - One output layer reintroduces the RGB color channels. Sigmoid
        activation function is used to make sure the output pixel values
        are in a range of (0,1), which represents the color intensity or
        saturation

    The following images show a progression of our model's image
    reconstruction behavior through fine-tuning, such as adding
    convolutional layers, increasing the latent space dimension, and
    adjusting the number of epochs.

    #fig("derain_tuning.jpg",
      [Reconstruction quality progressing through fine-tuning],
      alt: "Three increasingly recognizable CVAE reconstructions of the same scene")

    #btn(([Browse the source ↗], "https://github.com/ldjennings/deraining-tools"))

    = Dataset

    We used
    #link("https://drive.google.com/drive/folders/1e7R76s6vwUJxILOcAsthgDLPSnOrQ49K")[this dataset]
    of 861 rain-free and rain image pairs for training. This dataset was
    acquired from
    #link("https://github.com/rui1996/DeRaindrop")[this GitHub project]
    that developed a different deraining method. Below are examples of
    the image pairs:

    #fig("derain_pair.jpg",
      [A clean image (left) and its raindrop-degraded pair (right)],
      alt: "Side-by-side clean and rain-degraded photographs")

    #fig("derain_pair2.jpg",
      [Another clean/rain pair from the dataset],
      alt: "A second side-by-side clean and rain-degraded pair")

    = Example of Training Result

    #fig("derain_training.jpg",
      [Clean original, rain-degraded input, and the model's reconstruction],
      alt: "Clean image, rainy image, and blurry CVAE reconstruction side by side")

    = Example of Testing Result

    #fig("derain_testing.jpg",
      [Reconstructions of held-out test images],
      alt: "Three unrecognizable CVAE reconstructions of test images")

    = Conclusions

    The model performed somewhat successfully in training. It input
    images, identified significant hierarchal features of colored images,
    and reconstructed recognizable images without raindrop blurs.
    Unfortunately, when applying the model to testing data, the resulting
    images were not recognizable at all. The model needs significant
    further tuning and development to improve image reconstruction.
    Future work could include:

    - Different or ensemble approach:
      - Isolating regions distorted by rain and then only applying the
        VAE to those regions
      - Using perceptual loss metric such as VGG loss or Generative
        Adversarial Metrics, which favor features that humans actually
        see rather than raw pixels, and should produce better results
        than methods that just compare raw pixel values like MSE.
    - Training the model with an improved dataset (more diverse image
      pairs, real rain instead of synthetic rain)
    - Data augmentation and/or denoising prior to training, using more
      advanced methods to split the dataset and ensure the model isn't
      becoming overfitted
    - Further hyperparameter tuning

    = References

    - Wang, T., Yang, X., Xu, K., Chen, S., Zhang, Q., & Lau, R.
      "Spatial Attentive Single-Image Deraining with a High Quality Real
      Rain Dataset", CVPR 2019.
    - Porav, H., Bruls, T., & Newman, P. "I Can See Clearly Now: Image
      Restoration via De-Raining"
    - Li, S., Araujo, I. "Single Image Deraining: A Comprehensive
      Benchmark Analysis", CVPR 2019.
    - Zhao, Z., Yanyan, W., Haijun, Z., Yi, Y., Shuicheng, Y., & Wang,
      M. "Data-Driven Single Image Deraining: A Comprehensive Review and
      New Perspectives," Pattern Recognition 2023.
    - #link("https://github.com/nnUyi/DerainZoo")[Derain Zoo]: additional
      GitHub collection of deraining methods and datasets
    - #link("https://github.com/EvoCargo/RaindropsOnWindshield")[Raindrops
      on Windshield]: dataset of synthetic rain image pairs on car
      windshields, specific to autonomous vehicle applications
    - #link("https://www.crcv.ucf.edu/data/GMCP_Geolocalization/")[UCF
      Center for Research in Computer Vision]: dataset of images captured
      by Google Street View that were piped through the raindrop
      generator

    #post-nav("deraining")
  ]
] <deraining>
