abstract interface class I{{name.pascalCase()}}Api{

}

class {{name.pascalCase()}}ApiImpl implements I{{name.pascalCase()}}Api {
  final RestClient httpService;
  {{name.pascalCase()}}ApiImpl(this._httpService);
}