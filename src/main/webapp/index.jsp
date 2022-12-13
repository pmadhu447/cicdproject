<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8" />
    <title>Fruit Stock Management</title>
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/wingcss/0.1.8/wing.min.css"
    />
    <style>
      input[type='number'] {
        width: 100%;
        padding: 12px 20px;
        margin: 8px 0;
        display: inline-block;
        border: 1px solid #ccc;
        border-radius: 4px;
        box-sizing: border-box;
        -webkit-transition: 0.5s;
        transition: 0.5s;
        outline: 0;
        font-family: 'Open Sans', serif;
      }
    </style>
  </head>
  <body>
    <div class="container" id="app">
      <h1>Node.js Crud Application</h1>

      <p>
        This is for IMSSSSSS APPLICATION demonstrates how a Node.js application implements a
        CRUD endpoint to manage <em>fruits</em>. This management interface
        invokes the CRUD service endpoint, that interact with a PosgreSQL
        database .
      </p>

      <h3>Add/Edit a fruit</h3>

      <form @submit.prevent="update">
        <div class="row">
          <div class="col-6">
            <input
              v-model="form.name"
              type="text"
              placeholder="Name"
              ref="name"
              size="60"
            />
          </div>
          <div class="col-6">
            <input
              type="number"
              v-model="form.stock"
              placeholder="Stock"
              ref="stock"
              size="60"
              min="0"
            />
          </div>
        </div>
        <input type="submit" value="Save" />
      </form>

      <h3>Fruit List</h3>

      <div class="row">
        <div class="col-2">Name</div>
        <div class="col-2">Stock</div>
      </div>

      <div class="row" v-for="fruit in fruits">
        <div class="col-2">{{ fruit.name }}</div>
        <div class="col-2">{{ fruit.stock }}</div>
        <div class="col-8">
          <a @click="edit( fruit )" class="btn">Edit</a>
          <a @click="remove( fruit )" class="btn">Remove</a>
        </div>
      </div>
    </div>
    <script
      src="https://cdnjs.cloudflare.com/ajax/libs/vue/2.7.10/vue.min.js"
      integrity="sha512-H8u5mlZT1FD7MRlnUsODppkKyk+VEiCmncej8yZW1k/wUT90OQon0F9DSf/2Qh+7L/5UHd+xTLrMszjHEZc2BA=="
      crossorigin="anonymous"
      referrerpolicy="no-referrer"
    ></script>
    <script>
      const app = new Vue({
        el: '#app',
        data: {
          form: {
            id: -1,
            name: '',
            stock: 0,
          },
          fruits: [],
          method: '',
          url: '',
          data: {},
          fruit: '',
        },

        methods: {
          edit(fruit) {
            this.form.name = fruit.name;
            this.form.stock = parseInt(fruit.stock);
            this.form.id = fruit.id;
          },
          async remove(fruit) {
            await fetch(`/api/fruits/${fruit.id}`, {
              method: 'DELETE',
            })
              .then(this._success)
              .catch(this._error);
          },
          async _refreshPageData() {
            const result = await fetch('/api/fruits', {
              method: 'GET',
            });
            if (result.ok) {
              const resultData = await result.json();
              this.fruits = resultData;
            } else {
              console.log(result.statusText);
            }
          },
          async update() {
            this.form.name = this.$refs.name.value;
            this.form.stock = this.$refs.stock.value;
            if (this.form.id == -1) {
              this.method = 'POST';
              this.url = '/api/fruits';
              this.data.name = this.form.name;
              this.data.stock = this.form.stock;
            } else {
              this.method = 'PUT';
              this.url = '/api/fruits/' + this.form.id;
              this.data.name = this.form.name;
              this.data.stock = this.form.stock;
            }

            await fetch(this.url, {
              method: this.method,
              headers: {
                'Content-Type': 'application/json',
              },
              body: JSON.stringify(this.data),
            })
              .then(this._success)
              .catch(this._error);
          },
          _success(response) {
            this._refreshPageData();
            this._clearForm();
          },
          _error(response) {
            alert(
              response.data
                ? JSON.stringify(response.data)
                : response.statusText
            );
          },
          _clearForm() {
            this.form.name = '';
            this.form.stock = 0;
            this.form.id = -1;
          },
        },
        mounted: function () {
          this._refreshPageData();
        },
      });
    </script>
  </body>
</html>
