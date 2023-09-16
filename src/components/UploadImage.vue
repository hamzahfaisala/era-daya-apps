<template>
  <!-- form input gambar -->
  <div>
    <v-sheet width="500" class="mx-auto">
      <v-form ref="form" fast-fail @submit.prevent>
        <v-file-input
          v-model="image"
          :rules="imageRules"
          accept="image/png, image/jpeg, image/bmp"
          placeholder="Pick an Image"
          prepend-icon="mdi-camera"
          label="Image"
          show-size
          @click:clear="image = null, disableButton = true"
          @change="validate"
        ></v-file-input>
        <div class="mt-2 text-center">
          <v-btn :disabled="disableButton" type="submit" @click="submit" color="success">Submit</v-btn>
        </div>
      </v-form>
    </v-sheet>
  </div>

  <!-- galeri -->
  <div class="mt-16">
    <v-row>
      <v-col cols="3" v-for="imageUrl in imageUrl">
       <div class="mx-5 text-center">
        <img :src="imageUrl" alt="" style="max-width: 100%; height: 110px;">
       </div>
      </v-col>
    </v-row>
  </div>
</template>

<script>
  import axios from 'axios'

  export default {
    
    data: () => ({
      disableButton: true,
      valid: false,
      image:'',
      imageUrl: [],
      imageRules:[
        v => (v && 2000000 > v[0].size > 0) || 'Image is required and the size should be less than 2 MB!',
      ]
    }),

    created() {
     this.imageUrl = JSON.parse(localStorage.getItem("imageUrl") || '[]')
    },

    watch:{
      imageUrl(value){
        this.imageUrl = JSON.parse(localStorage.getItem("imageUrl") || '[]')
      }
    },

    methods: {
      async validate () {
        if(!this.image[0] || this.image[0].size > 2000000){
          this.disableButton = true
        }else{
          this.disableButton = false
        }
      },

      async submit(){
        this.disableButton= true
        const apiUrl = import.meta.env.VITE_API_ENDPOINT;

        try {
          const formData = new FormData();
          formData.append('image', this.image[0]);

          const response = await axios.post(apiUrl, formData, {
            headers: {
              'Content-Type': 'multipart/form-data',
            },
            params: {
              key: import.meta.env.VITE_CLIENT_API_KEY,
            },
          });

          if (response.data && response.data.data && response.data.data.url) {
            // The image was successfully uploaded
            this.imageUrl.push(response.data.data.url)
            localStorage.setItem("imageUrl", JSON.stringify(this.imageUrl));
            console.log(localStorage.imageUrl);
          } else {
            console.error('Failed to upload image:', response.data);
          }
        } catch (error) {
          console.error('Error uploading image:', error);
        }

        this.image = null
      }
    },
  }
</script>