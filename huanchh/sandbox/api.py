from fastapi import FastAPI


def get_app() -> FastAPI:
    api = FastAPI()

    @api.get('/')
    def root():  # pylint: disable=unused-variable
        return {'hello world'}

    return api


app = get_app()
